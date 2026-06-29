
#' Set a doFuture execution strategy
#'
#' @param strategy One of `"sequential"` (default), `"multisession"`, `"multicore"`, or `"mixed"`.
#' @param n_workers A positive numeric scalar or a function specifying the maximum number of parallel futures
#' that can be active at the same time before blocking.
#' If a function, it is called without arguments when the future is created and its value is used to configure the workers.
#' The function should return a numeric scalar.
#' Defaults to [future::availableCores()]`-1` if `NULL` (default), with `"multicore"` constraint in the relevant case.
#' Ignored if `strategy=="sequential"`.
#'
#' @return The `%dofuture%` operator from the `doFuture` package to use in a [foreach::foreach()] loop.
#' @importFrom foreach %do% %dopar%
#' @importFrom future availableCores plan sequential multisession multicore tweak
#' @importFrom doFuture registerDoFuture %dofuture%
#'
#' @keywords internal
set_doFuture_strategy <- function(strategy=c("sequential", "multisession", "multicore", "mixed"),
                                  n_workers=NULL){
  strategy <- match.arg(strategy)
  
  doFuture::registerDoFuture()
  if(strategy == "sequential"){
    future::plan(future::sequential)
    
  } else if (strategy == "multisession"){
    if(is.null(n_workers)){
      n_workers <- max(future::availableCores() - 1, 1)
    }
    future::plan(future::multisession, workers = n_workers)
    
  } else if (strategy == "multicore"){
    if(is.null(n_workers)){
      n_workers <- max(future::availableCores(constraints = "multicore") - 1, 1)
    }
    future::plan(future::multicore, workers = n_workers)
    
  } else if (strategy == "mixed"){
    if(is.null(n_workers)){
      n_workers <- max(future::availableCores() - 1, 1)
    }
    strategy_1 <- future::tweak(future::sequential)
    strategy_2 <- future::tweak(future::multisession, workers = n_workers)
    future::plan(list(strategy_1, strategy_2))
  }
  return(doFuture::`%dofuture%`)
}


#' End the currently set doFuture strategy
#'
#' @description Resets the default strategy using `future::plan("default")`.
#'
#' @importFrom future plan
#'
#' @keywords internal
end_doFuture_strategy <- function(){
  
  future::plan("default")
}


