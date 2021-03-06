################################################################################
#' An S4 class snap to represent single-nucleus accessibility object.
#'
#' Class snap defines a snap object.
#'
#' @slot des A character object describes the details of the experiment.
#' @slot barcode A character vector contains cell barcodes as rows.
#' @slot file A character vector contains the snap file that barcodes belong to.
#' @slot sample A character vector contains sample name.
#' @slot metaData A data.frame object contains meta data for barcodes.
#' @slot feature A GRanges object contains genomic features (bins).
#' @slot peak A GRanges object contains genomic features (peaks).
#' @slot bmat A Matrix object contains cellxbin count matrix.
#' @slot pmat A Matrix object contains cellxpeak count matrix.
#' @slot gmat A matrix object contains cellxgene count matrix.
#' @slot mmat A matrix object contains cellxmotif variability matrix.
#' @slot jmat A jaccard object that contains jaccard index matrix.
#' @slot smat A list object contains the linear dimentionality reduction result.
#' @slot graph A kgraph object that contains the knn graph.
#' @slot tsne A matrix object contains tsne coordinate.
#' @slot umap A matrix object contains umap coordinate.
#' @slot cluster A factor object contains cluster label.
#' @name snap-class
#' @rdname snap-class
#' @exportClass snap
#' @importFrom methods setClassUnion
methods::setClassUnion("MatrixOrmatrix", c("Matrix", "matrix"))
setClass("snap",
	slots=list(
	des="character",
	barcode="character",
	file="character",
	sample="character",
	metaData="data.frame",
	feature="GRanges",
	peak = "GRanges",
	bmat = "Matrix",
	pmat = "Matrix",
	gmat = "Matrix",
	mmat = "matrix",
	jmat = "jaccard",
	regModel = "numeric",
	smat = "dim.reduct",
	graph = "kgraph",
	tsne = "MatrixOrmatrix",
	umap = "MatrixOrmatrix",
	cluster = "factor"
	)
)

.valid.snap.feature <- function(object)
{
	if(length(object@feature) != ncol(object@bmat)){
		return("slot 'feature' have different length from 'bmat' column")		
	}
	NULL;
}

.valid.snap.peak <- function(object)
{
	if(length(object@peak) != ncol(object@pmat)){
		return("slot 'peak' have different length from 'pmat' column")		
	}
	NULL;
}

.valid.snap.barcode <- function(object)
{
	if(length(object@barcode) != nrow(object@metaData)){
		return("slot 'barcode' have different length from 'metaData'")		
	}
	NULL
}

.valid.snap <- function(object)
{
    #c(.valid.snap.barcode(object), .valid.snap.feature(object))
    c(.valid.snap.barcode(object), .valid.snap.peak(object), .valid.snap.feature(object));
}
methods::setValidity("snap", .valid.snap)


setMethod("show", signature = "snap",
	definition = function(object) {
		if((x=length(object@des)) > 0L){
			cat("description: ", object@des, "\n");
			cat("===================", "\n");			
		}
		cat("number of barcodes: ", ifelse(is.null(length(object@barcode)), 0, length(object@barcode)), "\n", sep="");
		cat("number of bins: ", ncol(object@bmat), "\n", sep="");
		cat("number of genes: ", ncol(object@gmat), "\n", sep="");
		cat("number of peaks: ", ncol(object@pmat), "\n", sep="");
		cat("number of motifs: ", ncol(object@mmat), "\n", sep="");
	}                              
)



