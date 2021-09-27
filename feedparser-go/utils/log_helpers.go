package utils

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
