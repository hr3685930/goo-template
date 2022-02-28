package errs

import (
	"github.com/hr3685930/pkg/http/gin"
	"net/http"
)

// BadRequest BadRequest
func BadRequest(msg string) *gin.HttpError {
	return gin.NewError(http.StatusBadRequest, 4400, msg)
}

// ResourceNotFound ResourceNotFound
func ResourceNotFound(msg string) *gin.HttpError {
	return gin.NewError(http.StatusNotFound, 4404, msg)
}

// AuthenticationFailed AuthenticationFailed
func AuthenticationFailed(msg string) *gin.HttpError {
	return gin.NewError(http.StatusUnauthorized, 4401, msg)
}

// AuthorizationFailed AuthorizationFailed
func AuthorizationFailed(msg string) *gin.HttpError {
	return gin.NewError(http.StatusForbidden, 4403, msg)
}

// Conflict Conflict
func Conflict(msg string) *gin.HttpError {
	return gin.NewError(http.StatusMethodNotAllowed, 4405, msg)
}

// ValidationFailed ValidationFailed
func ValidationFailed(msg string) *gin.HttpError {
	return gin.NewError(http.StatusUnprocessableEntity, 4422, msg)
}

//InternalError InternalError
func InternalError(msg string) *gin.HttpError {
	return gin.NewError(http.StatusInternalServerError, 5500, msg)
}
