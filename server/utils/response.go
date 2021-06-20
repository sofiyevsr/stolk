package utils

func SuccessResponse(body interface{}) (int, interface{}) {
	return 200, map[string]interface{}{"body": body}
}
