package utils

import (
	"errors"
	"fmt"
	"html"
	"net/url"
	"strings"
	"time"

	"github.com/microcosm-cc/bluemonday"
	"github.com/mmcdole/gofeed"
)

const (
	MAX_TITLE_LENGTH = 1000
	MAX_LINK_LENGTH  = 1000
)

func ConvertFeedsToLogFeeds(feeds []Feed) []int {
	initial := make([]int, 0)
	for _, v := range feeds {
		initial = append(initial, v.Id)
	}
	return initial
}

func MarkFeedAsProcessed(source_id int, processedFeeds *[]int) {
	feeds := *processedFeeds
	for i, fe := range feeds {
		if fe == source_id {
			feeds[i] = feeds[len(feeds)-1]
			// We do not need to put s[i] at the end, as it will be discarded anyway
			*processedFeeds = feeds[:len(feeds)-1]
			return
		}
	}
}

func tryParseDate(date string) (time.Time, error) {
	if date == "" {
		return time.Time{}, errors.New("date is empty")
	}
	if string(date[10]) == "+" {
		newDate := []byte(date)
		newDate[10] = 'T'
		newDate[len(newDate)-2] = ':'
		newDate = append(newDate, '0')
		parsedDate, err := time.Parse(time.RFC3339, string(newDate))
		if err == nil {
			return parsedDate.UTC(), nil
		}
	}
	parsedDate, err := time.Parse(time.RFC3339, date)
	if err != nil {
		return time.Time{}, err
	}
	return parsedDate.UTC(), nil
}

// Try to correct url
func tryParseLink(rawLink string) (string, error) {
	if rawLink == "" {
		return "", errors.New("link is nil")
	}
	if len(rawLink) > MAX_LINK_LENGTH {
		return "", errors.New("link is too long")
	}
	if strings.HasPrefix(rawLink, "//") {
		return "http:" + rawLink, nil
	}

	// some sources has two scheme so replace it
	if strings.Count(rawLink, "https:") > 1 {
		rawLink = strings.Replace(rawLink, "https:", "", 1)
	}

	link, err := url.ParseRequestURI(rawLink)
	if err != nil || link.Scheme == "" || link.Host == "" {
		fmt.Printf("ignoring link because of url parsing failed %s\n", rawLink)
		return "", errors.New("link is invalid")
	}
	return link.String(), nil
}

func stripHTMLTags(str string, unescape bool) (string, error) {
	if len(str) > MAX_TITLE_LENGTH {
		return "", errors.New("string is too long")
	}

	a := bluemonday.StrictPolicy()
	// escape some characters manually
	str = strings.ReplaceAll(str, "\\", "")
	escaped := a.Sanitize(str)

	if escaped == "" {
		return "", errors.New("can't parse string")
	}

	if unescape == true {
		escaped = html.UnescapeString(escaped)
	}

	return escaped, nil
}

func prepareFeed(feed *gofeed.Item, name string) {

	if strings.Contains(feed.Link, "lent.az") && strings.HasSuffix(feed.Link, "/1") {
		feed.Link = feed.Link[:len(feed.Link)-2]
	}
	if apaIndex := strings.Index(feed.Link, "apa.az"); apaIndex != -1 {
		lang := feed.Link[apaIndex+7 : apaIndex+9]
		if lang != "az" && lang != "ru" {
			feed.Link = feed.Link[:apaIndex] + name + feed.Link[apaIndex+6:]
		}
	}
}

func filterDuplicateAliases(ca []CatAlias, db []CatAlias) []CatAlias {
	var filteredCats []CatAlias
	for _, c := range ca {
		var exists bool
		for _, d := range db {
			if c.Alias == d.Alias {
				exists = true
			}
		}
		if exists == false {
			filteredCats = append(filteredCats, c)
		}
	}

	return filteredCats
}
