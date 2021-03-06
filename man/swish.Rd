% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/swish.R
\name{swish}
\alias{swish}
\title{swish: SAMseq With Inferential Samples Helps}
\usage{
swish(
  y,
  x,
  cov = NULL,
  pair = NULL,
  interaction = FALSE,
  nperms = 100,
  estPi0 = FALSE,
  qvaluePkg = "qvalue",
  pc = 5,
  nRandomPairs = 30,
  fast = 1,
  quiet = FALSE
)
}
\arguments{
\item{y}{a SummarizedExperiment containing the inferential replicate
matrices of median-ratio-scaled TPM as assays 'infRep1', 'infRep2', etc.}

\item{x}{the name of the condition variable. A factor with two
levels for a two group analysis (possible to adjust for covariate
or matched samples, see next two arguments)}

\item{cov}{the name of the covariate for adjustment.
If provided a stratified Wilcoxon in performed.
Cannot be used with \code{pair}}

\item{pair}{the name of the pair variable, which should be the
number of the pair. Can be an integer or factor.
If specified, a signed rank test is used
to build the statistic. All samples across \code{x} must be
pairs if this is specified. Cannot be used with \code{cov}.}

\item{interaction}{logical, whether to perform a test of an interaction
between \code{x} and \code{cov}. These are different than the other
tests produced by the software, in that they focus on a difference
in the log2 fold change across levels of \code{x} when comparing
the two levels in \code{cov}. If \code{pair} is specified, this
will perform a Wilcoxon rank sum test on the two groups
of matched sample LFCs. If \code{pair} is not included, multiple
random pairs of samples within the two groups are chosen,
and again a Wilcoxon rank sum test compared the LFCs across groups.}

\item{nperms}{the number of permutations. if set above the possible
number of permutations, the function will print a message that the
value is set to the maximum number of permutations possible}

\item{estPi0}{logical, whether to estimate pi0}

\item{qvaluePkg}{character, which package to use for q-value estimation,
\code{samr} or \code{qvalue}}

\item{pc}{pseudocount for finite estimation of \code{log2FC}, not used
in calculation of test statistics, \code{locfdr} or \code{qvalue}}

\item{nRandomPairs}{the number of random pseudo-pairs (only used with
\code{interaction=TRUE} and un-matched samples) to use to calculate
the test statistic}

\item{fast}{an integer, toggles different methods based on speed
(\code{fast=1} is default).
'0' involves recomputing ranks of the inferential replicates for each permutation,
'1' is roughly 10x faster by avoiding re-computing ranks for each permutation.
The \code{fast} argument is only used/relevant for the following three
experimental designs: (1) two group Wilcoxon, (2) stratified Wilcoxon, e.g.
\code{cov} is specified, and (3) the paired interaction test,
e.g. \code{pair} and \code{cov} are specified. For paired design and
general interaction test, there are not fast/slow alternatives.}

\item{quiet}{display no messages}
}
\value{
a SummarizedExperiment with metadata columns added:
the statistic (either a centered Wilcoxon Mann-Whitney
or a signed rank statistic, aggregated over inferential replicates),
a log2 fold change (the median over inferential replicates,
and averaged over pairs or groups (if groups, weighted by sample size),
the local FDR and q-value, as estimated by the \code{samr} package.
}
\description{
swish: SAMseq With Inferential Samples Helps
}
\examples{

library(SummarizedExperiment)
set.seed(1)
y <- makeSimSwishData()
y <- scaleInfReps(y)
y <- labelKeep(y)
y <- swish(y, x="condition")

# histogram of the swish statistics
hist(mcols(y)$stat, breaks=40, col="grey")
cols = rep(c("blue","purple","red"),each=2)
for (i in 1:6) {
  arrows(mcols(y)$stat[i], 20,
         mcols(y)$stat[i], 10,
         col=cols[i], length=.1, lwd=2)
}

# plot inferential replicates
plotInfReps(y, 1, "condition")
plotInfReps(y, 3, "condition")
plotInfReps(y, 5, "condition")

}
\references{
The citation for \code{swish} method is:

Anqi Zhu, Avi Srivastava, Joseph G Ibrahim, Rob Patro, Michael I Love
"Nonparametric expression analysis using inferential replicate counts"
Nucleic Acids Research (2019). \url{https://doi.org/10.1093/nar/gkz622}

The \code{swish} method builds upon the \code{SAMseq} method,
and extends it by incorporating inferential uncertainty, as well
as providing methods for additional experimental designs (see vignette).

For reference, the publication describing the \code{SAMseq} method is:

Jun Li and Robert Tibshirani "Finding consistent patterns:
A nonparametric approach for identifying differential expression
in RNA-Seq data" Stat Methods Med Res (2013).
\url{https://doi.org/10.1177/0962280211428386}
}
