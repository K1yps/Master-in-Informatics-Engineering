sig User {
	follows : set User,
	sees : set Photo,
	posts : set Photo,
	suggested : set User
}

sig Influencer extends User {}

sig Photo {
	date : one Day
}
sig Ad extends Photo {}

sig Day {}

// Specify the following properties
// You can check their correctness with the different commands and
// when specifying each property you can assume all the previous ones to be true

pred inv1 {
	// Every image is posted be one user
	all p : Photo | one u : User | u -> p in posts
}


pred inv2 {
  	all x : User | x -> x not in follows 
    //all x : User | all y : User | x -> y in follows implies x != y
	// An user cannot follow itself.

}


pred inv3 {
	// An user only sees (non ad) photos posted by followed users.
  	// Ads can be seen by everyone.
  	all u1 : User, p : Photo | some u2 : User | p in Ad or ( u1 -> p in sees implies u1 -> u2 in follows and u2 -> p in posts)
  	
}


pred inv4 {
	// If an user posts an ad then all its posts should be labelled as ads   
 	all a : Ad, u : User, p : Photo | u -> a in posts and u -> p in posts implies p in Ad
}


pred inv5 {
	// Influencers are followed by everyone else
  	

}


pred inv6 {
	// Influencers post every day

}


pred inv7 {
	// Suggested are other users followed by followers but not yet followed
	
}


pred inv8 {
	// An user only sees ads from followed or suggested users

}
