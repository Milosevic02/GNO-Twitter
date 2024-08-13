package twitter

import(
	"std"
	"time"
)

var(
	posts []*Post
	idCounter uint
)

type Post struct{
	id uint

	text string
	author std.Address
	createdAt time.Time

}

