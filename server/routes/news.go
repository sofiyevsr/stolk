package routes

import (
	"feed-server/controllers"

	"github.com/labstack/echo/v4"
)

func NewsRoutes(e *echo.Echo) {
	g := e.Group("/news")
	controllers.NewsController(g)
}
