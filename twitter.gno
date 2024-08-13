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
	upvotes uint
	downvotes uint
	upvoters []std.Address
	downvoters []std.Address

}

func AddPost(text string) uint{
	if text == ""{
		panic("post text cannot be empty")
	}

	p:=&Post{
		text:text,
		id:idCounter,
		author:std.PrevRealm().Addr(),
		createdAt:time.Now(),

	}
	posts = append(posts,p)
	idCounter++

	return p.id
}


func RemovePost(id uint){
	caller := std.PrevRealm().Addr()

	idx,p := getPost(id)

	if p == nil {
		panic("could not find post with specified id")
	}

	if p.author != caller{
		panic("you are not the author of this post!")
	}

	posts = append(posts[:idx], posts[idx+1:]...)

}

func hasVoted(caller std.Address, upvote bool, p *Post) bool {
	if upvote {
		for _, a := range p.upvoters {
			if a == caller {
				return true
			}
		}
	} else {
		for _, a := range p.downvoters {
			if a == caller {
				return true
			}
		}
	}
	return false
}

func handleVote(id uint, upvote bool) {
	_, p := getPost(id)
	caller := std.PrevRealm().Addr()
	if p == nil {
		panic("could not find post with specified id")
	}
	if hasVoted(caller, upvote, p) {
		panic("You already voted")
	}
	if upvote {
		p.upvoters = append(p.upvoters, caller)
		p.upvotes++
	} else {
		p.downvoters = append(p.downvoters, caller)
		p.downvotes++
	}
}

func Upvote(id uint) {
	handleVote(id, true)
}


func Downvote(id uint) {
	handleVote(id, false)
}

func getPost(id uint) (int,*Post){
	for i,p := range posts{
		if p.id == id{
			return i,p
		}
	}

	return -1,nil
}
