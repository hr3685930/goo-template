package export

import (
	"{{ .ProjectName }}/configs"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

var dontReportGrpcCode = []codes.Code{
	//codes.NotFound,
}

//GRPCErrorReport GRPCErrorReport
func GRPCErrorReport(md metadata.MD, req interface{}, stack string, status *status.Status) {
	isDontReport := false
	for _, value := range dontReportGrpcCode {
		if value == status.Code() {
			isDontReport = true
		}
	}
	errURL := configs.ENV.App.ErrReport
	if errURL != "" && !isDontReport {
		request := map[string]interface{}{
			"header": md,
			"params": req,
		}

		app := map[string]string{
			"name":        configs.ENV.App.Name,
			"environment": configs.ENV.App.Env,
		}

		exception := map[string]interface{}{
			"code":  status.Code().String(),
			"trace": stack,
		}

		option := map[string]interface{}{
			"error_type": "error",
			"app":        app,
			"exception":  exception,
			"request":    request,
		}
        Report(option, "grpc error")
	}
}
