package controllers

import (
	"feed-server/helpers"
	"feed-server/utils"
	"fmt"

	"github.com/labstack/echo/v4"
)

type query struct {
	Limit uint `query:"limit"`
	Id    uint `query:"id"`
}

func NewsController(g *echo.Group) {
	g.GET("/all", func(c echo.Context) error {
		params := query{}
		if err := c.Bind(&params); err != nil {
			fmt.Println(err)
		}
		fmt.Println(params)
		news, err := helpers.GetNews(params.Id, params.Limit)
		if err != nil {
			panic(err)
		}
		return c.JSON(utils.SuccessResponse(news))
	})
}
