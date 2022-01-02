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
	MAX_TITLE_LENGTH = 255
	MAX_LINK_LENGTH  = 450
)

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

	rawLink = strings.Trim(rawLink, " ")

	// some sources has two scheme so replace it
	if strings.Contains(rawLink, "https:https:") {
		rawLink = strings.Replace(rawLink, "https:https:", "https:", 1)
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

// Specific corrections for each feed
// Links that required further actions for now:
// lent.az
// apa.az
// TODO write test for checking if corresponding feeds will work if problem solved
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
