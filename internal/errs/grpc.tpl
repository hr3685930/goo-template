package errs

import (
	"github.com/hr3685930/pkg/rpc"
	"google.golang.org/grpc/codes"
)

// RequestTimeout 超时
func RequestTimeout(msg string) error {
	return rpc.Err(codes.Canceled, msg)
}

// InternalError 系统错误
func InternalError(msg string) error {
	return rpc.Err(codes.Unknown, msg)
}

// ValidationFailed 参数失败
func ValidationFailed(msg string) error {
	return rpc.Err(codes.InvalidArgument, msg)
}

// BadRequest BadRequest
func BadRequest(msg string) error {
	return rpc.Err(codes.OutOfRange, msg)
}

// ResourceNotFound not fount
func ResourceNotFound(msg string) error {
	return rpc.Err(codes.NotFound, msg)
}

// Conflict conflict
func Conflict(msg string) error {
	return rpc.Err(codes.AlreadyExists, msg)
}

// AuthorizationFailed authorization failed
func AuthorizationFailed(msg string) error {
	return rpc.Err(codes.PermissionDenied, msg)
}

// AuthenticationFailed authentication failed
func AuthenticationFailed(msg string) error {
	return rpc.Err(codes.Unauthenticated, msg)
}

// TooManyRequests Too Many Requests
func TooManyRequests(msg string) error {
	return rpc.Err(codes.ResourceExhausted, msg)
}

// ServiceUnavailable Service Unavailable
func ServiceUnavailable(msg string) error {
	return rpc.Err(codes.Unavailable, msg)
}


// DtmError Dtm Error
func DtmError(msg string) error {
	return rpc.Err(codes.Aborted, msg)
}

// DtmOngoing Dtm Ongoing
func DtmOngoing(msg string) error {
	return rpc.Err(codes.FailedPrecondition, msg)
}

