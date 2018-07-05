#!/usr/bin/env Rscript

suppressMessages(library(dplyr))
suppressMessages(library(logspline))
suppressMessages(library(mixtools))
suppressMessages(library(plyr))
suppressMessages(library(tidyr))
suppressMessages(library(TTR))
options(scipen=5)
options(warn=-1)

# EDIT THESE VALUES ONLY
runs <- 10000
times_per_week <- 6
stoploss <- -3000 # set to NULL if none
csvdata <- read.csv(file='data.txt', header=FALSE, sep=",")
mm <- as.integer(csvdata$V1)
times <- as.character(csvdata$V2)
# DON'T EDIT ANYTHING AFTER THIS


times_per_year <- times_per_week * 52
times_per_month <- as.integer(round(times_per_year / 12, 0))

rle <- function(x, fun) {
  if (!is.vector(x) && !is.list(x))
    stop("'x' must be a vector of an atomic type")
  n <- length(x)

  if (n == 0L)
    return(structure(list(lengths = integer(), values = x),
                     class = "rle"))

  if (missing(fun)) {
    y <- x[-1L] != x[-n]
    i <- c(which(y | is.na(y)), n)
    structure(list(lengths = diff(c(0L, i)), values = x[i]),
              class = "rle")
  } else {
    if (n == 1L)
      return(structure(list(lengths = 1, values = x),
                       class = "rle"))
    res <- vector('list', length(x))
    reslen <- 0
    currun <- 0
    currunlen <- 0

    for (i in 1:n) {
      cur <- x[i]
      prev <- ifelse(i==1, x[i], x[i-1])
      test <- do.call(fun, list(cur)) == do.call(fun, list(prev))

      if (test) {
        currun <- currun + cur
        currunlen <- currunlen + 1
      } else {
        reslen <- reslen + 1
        res[[reslen]] <- c(currunlen, currun)
        currun <- cur
        currunlen <- 1
      }

      if (i == length(x)) {
        reslen <- reslen + 1
        res[[reslen]] <- c(1, currun)
      }
    }

    lengths <- unlist(res[-which(sapply(res, is.null))])[c(TRUE, FALSE)]
    values <- unlist(res[-which(sapply(res, is.null))])[c(FALSE, TRUE)]
    structure(list(lengths = lengths, values = values),
              class = "rle")
  }
}

chunkedRes <- function(data, size) {
  res <- suppressWarnings(apply(data, 1, function(row) {
    splits <- rowSums(do.call(rbind, split(row, ceiling(seq_along(row) / size))))
    return(splits)
  }))

  if (is.null(nrow(res))) {
    return(t(t(res)))
  } else {
    return(t(res))
  }
}

calcWrs <- function(data) {
  apply(data, 1, function(row) { round(sum(row>0) / ncol(data), 2) })
}

streaks <- function(data) {
  res <- unlist(apply(data, 1, function(row) {
    r <- rle(sign(row))
    r$lengths * r$values
  }))

  df <- count(res)
  total <- sum(df$freq)
  df <- mutate(df, prob = round(freq / total, 4))
  rm <- which(with(df, prob < 0.0001))

  if (length(rm > 0)) {
    df <- df[-rm,]
  }

  return(df)
}

longest_upswing <- function(data) {
  ifelse(length(data$x[which(data$x>0)])>0, max(data$x[which(data$x>0)]), 'NA')
}

longest_downswing <- function(data) {
  ifelse(length(data$x[which(data$x<0)])>0, min(data$x[which(data$x<0)]), 'NA')
}

maxupswing <- function(data) {
  vals_by_max <- apply(data, 1, function(row) {
    strks <- rle(row, sign)$values
    max(strks)
  })

  check_pos <- vals_by_max[which(vals_by_max>0)]

  if (length(check_pos)>0) {
    list(value = max(vals_by_max, na.rm=TRUE), idx = which.max(vals_by_max))
  } else {
    list(value = NA, idx = 0)
  }
}

maxdownswing <- function(data) {
  vals_by_min <- apply(data, 1, function(row) {
    strks <- rle(row, sign)$values
    min(strks)
  })

  check_neg <- vals_by_min[which(vals_by_min<0)]

  if (length(check_neg)>0) {
    list(value = min(vals_by_min, na.rm=TRUE), idx = which.min(vals_by_min))
  } else {
    list(value = NA, idx = 0)
  }
}

avg_upswing <- function(data) {
  vals <- apply(data, 1, function(row) {
    strks <- rle(row, sign)$values
    pos <- which(strks>0)
    strks <- strks[pos]
    mean(strks)
  })
  as.integer(mean(vals, na.rm=TRUE))
}

avg_downswing <- function(data) {
  vals <- apply(data, 1, function(row) {
    strks <- rle(row, sign)$values
    neg <- which(strks<0)
    strks <- strks[neg]
    mean(strks)
  })
  as.integer(mean(vals, na.rm=TRUE))
}

generate_legend <- function(best_i, worst_i, largest_pls_i, largest_min_i, largest_weekly_pls_i, largest_weekly_min_i, largest_monthly_pls_i, largest_monthly_min_i) {
  labels <- c("Best","Largest Upswing","Largest Weekly Upswing","Largest Monthly Upswing","Worst","Largest Downswing","Largest Weekly Downswing","Largest Monthly Downswing","Actual")
  colors <- c("green","greenyellow","green3","green4","red","red3","red4","hotpink","black")
  ltys <- c(1,1,1,1,1,1,1,1,1)
  lwds <- c(4,3,2,1,4,3,2,1,5)


  legend("topleft",
         legend=labels,
         col=colors,
         lty=ltys,
         lwd=lwds,
         bg="white",
         cex=0.5
         )
}

if (is.null(stoploss)) {
  distFunc <- logspline(mm, penalty=0.01)
} else {
  distFunc <- logspline(mm, lbound = stoploss, penalty=0.01)
}

sample <- matrix(nrow = runs, ncol = times_per_year)

for (i in 1:runs) {
  new_row <- as.integer(round(rlogspline(times_per_year, distFunc)))

  while (is.na(new_row)) {
    new_row <- as.integer(round(rlogspline(times_per_year, distFunc)))
  }

  sample[i,] <- new_row
}

cat("\n")
cat("==========================================================================\n")
cat("Session Stats\n")
cat("==========================================================================\n")
cat("\n")

wrs <- calcWrs(sample)
strks <- streaks(sample)
longest_pls <- longest_upswing(strks)
longest_min <- longest_downswing(strks)
largest_pls <- maxupswing(sample)
largest_min <- maxdownswing(sample)
avg_pls <- avg_upswing(sample)
avg_min <- avg_downswing(sample)

cat("Avg won:", as.integer(mean(sample)), "\n")
cat("Best:", max(sample), "\n")
cat("Worst:", min(sample), "\n")
cat("WR:", round(mean(wrs), 2), "\n")
cat("Best WR:", max(wrs), "\n")
cat("Worst WR:", min(wrs), "\n")
cat("Longest Upswing:", longest_pls, "\n")
cat("Largest Upswing:", largest_pls$value, "\n")
cat("Avg Upswing:", avg_pls, "\n")
cat("Longest Downswing:", longest_min, "\n")
cat("Largest Downswing:", largest_min$value, "\n")
cat("Avg Downswing:", avg_min, "\n")

cat("\n")
cat("==========================================================================\n")
cat("Weekly Stats\n")
cat("==========================================================================\n")
cat("\n")

weekly_res <- chunkedRes(sample, times_per_week)
weekly_wrs <- calcWrs(weekly_res)
weekly_strks <- streaks(weekly_res)
longest_weekly_pls <- longest_upswing(weekly_strks)
longest_weekly_min <- longest_downswing(weekly_strks)
largest_weekly_pls <- maxupswing(weekly_res)
largest_weekly_min <- maxdownswing(weekly_res)
avg_weekly_pls <- avg_upswing(weekly_res)
avg_weekly_min <- avg_downswing(weekly_res)

cat("Avg won:", as.integer(mean(weekly_res)), "\n")
cat("Best:", max(weekly_res), "\n")
cat("Worst:", min(weekly_res), "\n")
cat("Weekly WR:", round(mean(weekly_wrs), 2), "\n")
cat("Best WR:", max(weekly_wrs), "\n")
cat("Worst WR:", min(weekly_wrs), "\n")
cat("Longest Upswing:", longest_weekly_pls, "\n")
cat("Largest Upswing:", largest_weekly_pls$value, "\n")
cat("Avg Upswing:", avg_weekly_pls, "\n")
cat("Longest Downswing:", longest_weekly_min, "\n")
cat("Largest Downswing:", largest_weekly_min$value, "\n")
cat("Avg Downswing:", avg_weekly_min, "\n")

cat("\n")
cat("==========================================================================\n")
cat("Monthly Stats\n")
cat("==========================================================================\n")
cat("\n")

monthly_res <- chunkedRes(sample, times_per_month)
monthly_wrs <- calcWrs(monthly_res)
monthly_strks <- streaks(monthly_res)
longest_monthly_pls <- longest_upswing(monthly_strks)
longest_monthly_min <- longest_downswing(monthly_strks)
largest_monthly_pls <- maxupswing(monthly_res)
largest_monthly_min <- maxdownswing(monthly_res)
avg_monthly_pls <- avg_upswing(monthly_res)
avg_monthly_min <- avg_downswing(monthly_res)

cat("Avg won:", as.integer(mean(monthly_res)), "\n")
cat("Best:", max(monthly_res), "\n")
cat("Worst:", min(monthly_res), "\n")
cat("Monthly WR:", round(mean(monthly_wrs), 2), "\n")
cat("Best WR:", max(monthly_wrs), "\n")
cat("Worst WR:", min(monthly_wrs), "\n")
cat("Longest Upswing:", longest_monthly_pls, "\n")
cat("Largest Upswing:", largest_monthly_pls$value, "\n")
cat("Avg Upswing:", avg_monthly_pls, "\n")
cat("Longest Downswing:", longest_monthly_min, "\n")
cat("Largest Downswing:", largest_monthly_min$value, "\n")
cat("Avg Downswing:", avg_monthly_min, "\n")

cat("\n")
cat("==========================================================================\n")
cat("Yearly Stats\n")
cat("==========================================================================\n")
cat("\n")

yearly_res <- chunkedRes(sample, times_per_year)
yearly_wrs <- calcWrs(yearly_res)
yearly_strks <- streaks(yearly_res)
longest_yearly_pls <- longest_upswing(yearly_strks)
longest_yearly_min <- longest_downswing(yearly_strks)
largest_yearly_pls <- maxupswing(yearly_res)
largest_yearly_min <- maxdownswing(yearly_res)
avg_yearly_pls <- avg_upswing(yearly_res)
avg_yearly_min <- avg_downswing(yearly_res)

cat("Avg won:", as.integer(mean(yearly_res)), "\n")
cat("Best:", max(yearly_res), "\n")
cat("Worst:", min(yearly_res), "\n")
cat("Yearly WR:", round(mean(yearly_wrs), 2), "\n")
cat("Best WR:", max(yearly_wrs), "\n")
cat("Worst WR:", min(yearly_wrs), "\n")
cat("Longest Upswing:", longest_yearly_pls, "\n")
cat("Largest Upswing:", largest_yearly_pls$value, "\n")
cat("Avg Upswing:", avg_yearly_pls, "\n")
cat("Longest Downswing:", longest_yearly_min, "\n")
cat("Largest Downswing:", largest_yearly_min$value, "\n")
cat("Avg Downswing:", avg_yearly_min, "\n")

cat("\n")
cat("==========================================================================\n")

pdf('rplot.pdf')

plot(distFunc, ann=FALSE, lwd=3)
hist(mm, breaks=15, freq=FALSE, add=TRUE)
title("Probability Distribution Curve")

best_i <- which(rowSums(sample) == max(rowSums(sample)))
worst_i <- which(rowSums(sample) == min(rowSums(sample)))
best <- cumsum(sample[best_i,])
worst <- cumsum(sample[worst_i,])
largest_upswing <- cumsum(sample[largest_pls$idx,])
largest_downswing <- cumsum(sample[largest_min$idx,])
largest_weekly_upswing <- cumsum(sample[largest_weekly_pls$idx,])
largest_weekly_downswing <- cumsum(sample[largest_weekly_min$idx,])
largest_monthly_upswing <- cumsum(sample[largest_monthly_pls$idx,])
largest_monthly_downswing <- cumsum(sample[largest_monthly_min$idx,])
ylim <- range(c(best,worst,largest_upswing,largest_downswing,largest_weekly_upswing,largest_weekly_downswing,largest_monthly_upswing,largest_monthly_downswing))

plot(best, type = 'l', ylim=ylim, main=paste("Samples (out of", runs, "runs)"),xlab="",ylab="",axes=FALSE)
at <- seq(0, times_per_year, by=times_per_week)
axis(3, at=at, labels=lead((at %/% times_per_week)), tck=1, lty=6, col="lightgray", cex.axis=0.6)
mtext("Week", side=3)
at <- seq(0, times_per_year, by=times_per_month)
axis(1, at=at, labels=month.abb[lead((at %/% times_per_month))], tck=1, lty=1, col="black", cex.axis=0.6)
mtext("Month", side=1)
tick_step <- (max(ylim) - min(ylim)) %/% 15
at <- seq(min(ylim), max(ylim), by=tick_step)
axis(2, at=at, las=1, cex.axis=0.6, labels=paste0("$", formatC(at, format="d", big.mark=",")))
abline(h=at, lty=6, col="lightgray")
generate_legend(best_i,
                worst_i,
                largest_pls,
                largest_min,
                largest_weekly_pls,
                largest_weekly_min,
                largest_monthly_pls,
                largest_monthly_min
                )
lines(best, lty=1, lwd=4, col ="green")
lines(worst, lty=1, lwd=4, col="red")
lines(largest_upswing, lty=1, lwd=3, col="greenyellow")
lines(largest_weekly_upswing, lty=1, lwd=2, col="green3")
lines(largest_monthly_upswing, lty=1, lwd=1, col="green4")
lines(largest_downswing, lty=1, lwd=3, col="red3")
lines(largest_weekly_downswing, lty=1, lwd=2, col="red4")
lines(largest_monthly_downswing, lty=1, lwd=1, col="hotpink")
lines(cumsum(mm), lty=1, lwd=5, col = "black")

if (!is.null(times)) {
  time_elems <- strsplit(times, ":")
  time_vect <- sapply(time_elems, function(x) as.numeric(c(rep(0, 2 - length(x)), x)))
  time_vect <- (time_vect[1,] * 60 + time_vect[2,]) / 60
  total_time_vect <- cumsum(time_vect)
  total_won <- cumsum(mm)
  wr <- mm / time_vect
  cumwr <- total_won / total_time_vect
  sma_weekly <- SMA(mm / time_vect, n=times_per_week)
  sma_monthly <- SMA(mm / time_vect, n=times_per_month)
  ylim <- range(c(wr, cumwr, sma_weekly, sma_monthly), na.rm=TRUE)
  par(mar=c(5.1, 4.1, 4.1, 5.1))
  plot(cumwr, type="l", ylim=ylim, main="Win Rate", xlab="Sessions", ylab="Win Rate", yaxt="n")
  lines(wr, col="blue")
  lines(SMA(mm / time_vect, n=times_per_week), col="green")
  lines(SMA(mm / time_vect, n=times_per_month), col="red")
  tick_step <- 25 #(max(ylim) - min(ylim)) %/% 15
  at <- seq(min(ylim), max(ylim), by=tick_step)
  axis(2, at=at, las=1, cex.axis=0.6, labels=paste0("$", formatC(at, format="d", big.mark=","), "hr"))
  axis(4, at=at, las=1, cex.axis=0.6, labels=paste0("$", formatC(at, format="d", big.mark=","), "hr"))
  abline(h=at, lty=6, col="lightgray")
  legend("bottomright",
         legend=c("Avg WR", "Session WR", paste(times_per_week, "day SMA"), paste(times_per_month, "day SMA")),
         col=c("black", "blue", "green", "red"),
         lty=c(1,1,1,1),
         bg="white",
         cex=0.5
         )
}

mp <- barplot(strks$prob, axes = FALSE, main="Streak Probabilities")
grid(nx=NA, ny=NULL)
axis(1, at = mp, labels = strks$x)
axis(2, seq(0,1, by=0.05), las=1)
barplot(strks$prob, axes = FALSE, add=TRUE)

mp <- barplot(weekly_strks$prob, axes = FALSE, main="Weekly Streak Probabilities")
grid(nx=NA, ny=NULL)
axis(1, at = mp, labels = weekly_strks$x)
axis(2, seq(0,1, by=0.05), las=1)
barplot(weekly_strks$prob, axes = FALSE, add=TRUE)

mp <- barplot(monthly_strks$prob, axes = FALSE, main="Monthly Streak Probabilities")
grid(nx=NA, ny=NULL)
axis(1, at = mp, labels = monthly_strks$x)
axis(2, seq(0,1, by=0.05), las=1)
barplot(monthly_strks$prob, axes = FALSE, add=TRUE)

mp <- barplot(yearly_strks$prob, axes = FALSE, log="y", main="Yearly Streak Probabilities")
grid(nx=NA, ny=NULL)
axis(1, at = mp, labels = yearly_strks$x)
axis(2, seq(0,1, by=0.05),, las=1)
barplot(yearly_strks$prob, axes = FALSE, log="y", add=TRUE)
