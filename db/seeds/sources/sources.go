package sources

import (
	"encoding/json"
	"io/ioutil"
)

type feed struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
	Link string `json:"link"`
}

func Sources() ([]feed, error) {
	data, err := ioutil.ReadFile("seeds/sources/feeds.json")
	if err != nil {
		return nil, err
	}
	parsed := make(map[string][]feed)
	if err := json.Unmarshal(data, &parsed); err != nil {
		return nil, err
	}
	var parsedFeeds []feed
	parsedFeeds = parsed["feeds"]
	return parsedFeeds, nil
}
