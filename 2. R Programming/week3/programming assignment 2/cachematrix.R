## Matrix inversion is a computationally expensive opteration; finding the inverse of large
## matrices has the potential to produce long running times.  The functions defined here address
## this problem by taking advantage of the concept of caching; in other words, the value of interest
## (in this case, the matrix inverse) is calculated once and then stored so that subsequent requests 
## for the same matrix inverse can be looked up instead of computed.

## NOTE: These functions assume that they will only be passed invertible matrices. 

## makeCacheMatrix creates and returns a special data structure capable of storing and returning a 
## matrix as well as its inverse.  This data structure consists of a list of four functions for 
## accessing and manipulating the internally stored matrix and its respective inverse.

makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL           # makeCacheMatrix's environment is used to store the matrix and its inverse (x and inv)
  set <- function(y) {
    x <<- y
    inv <<- NULL        # <<- operators are used to assign values to variables defined outside of the function's environment
  }
  get <- function() x
  setInverse <- function(inverse) inv <<- inverse
  getInverse <- function() inv
  list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}


## cacheSolve takes as a parameter one of the special data structures produced by makeCacheMatrix and returns the inverse of its 
## internally stored matrix.  It uses the data structure's internal functions to check whether or not the matrix has had its inverse 
## previously computed.  If so, it invokes the 'getInverse' function in order to look up the matrix inverse instead of computing it; 
## otherwise, the matrix inverse is computed, stored for future use, and returned.

cacheSolve <- function(x, ...) {
  inv <- x$getInverse()
  if(!is.null(inv)) {
    message('Getting cached matrix inverse')
    return(inv)
  }
  mat <- x$get()
  inv <- solve(mat, ...)
  x$setInverse(inv)
  inv
}
