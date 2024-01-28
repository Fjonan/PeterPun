extends Node

var words = [
	  "Time flies like an arrow. Fruit flies like a banana",
  "To the guy who invented zero, thanks for nothing",
  "Geology rocks",
  "Need an ark to save two of every animal? I noah guy",
  "I dont trust stairs. theyre always up to something",
  "Why was Dumbo sad? He felt irrelephant",
  "Becoming a vegetarian is one big missed steak",
  "I was wondering why the ball was getting bigger. Then it hit me",
  "Some aquatic mammals at the zoo escaped. It was otter chaos",
  "Long fairy tales have a tendency to dragon",
  "I made a pun about the wind but it blows",
  "Getting the ability to fly would be so uplifting",
  "England doesnt have a kidney bank, but a Liverpool",
  "What do you call the wife of a hippie? Mississippi",
  "A cross-eyed teacher couldnt control his pupils",
  "What washes up on tiny beaches? Microwaves",
  "German sausage jokes are just the wurst",
  "What do you call the ghost of a chicken? Poultry-geist",
  "What do you call an alligator in a vest? Investigator",
  "How does Moses make coffee? Hebrews it",
  "Somebody stole all my lamps. I couldnt be more de-lighted",
  "I bought a boat because it was for sail",
  "Im reading a book about anti-gravity. Its impossible to put down",
  "How did the picture end up in jail? It was framed",
  "My ex still misses me. But her aim is starting to improve",
  "Coffee has a rough time. Gets mugged every morning",
  "What did sushi say to the bee? Wasabee!",
  "Why did the cat go to the vet? Was not feline fine",
  "What should a lawyer wear to court? A good lawsuit",
  "Quickest way to make antifreeze? Steal her blanket",
  "How to make a good egg-roll? Push it down a hill",
  "Got hit with a can of soda. Was lucky it was a soft drink",
  "The past, present, and future walk into a bar. It was tense",
  "Dont be intimidated by advanced math. Its easy as pi",
  "One lung to another: we belung together",
  "I asked a Frenchman if he played video games. He said Wii",
  "Why are frogs so happy? They eat whatever bugs them",
  "Heard a cheese factory exploded in France. Nothing left but de Brie!",
  "Im no cheetah, youre lion!",
  "What does a clock do when its hungry? It goes back for seconds",
  "Whats Americas favorite soda? Mini soda",
  "I have a few jokes about unemployed people, but none of them work",
  "I have a split personality, said Tom, being frank",
  "How do you make holy water? You boil the hell out of it",
  "Will glass coffins be a success? Remains to be seen",
  "When life gives you melons, you make melonade",
  "Kleptomaniacs always take things literally",
  "difference between a hippo and a zippo? One is heavy, the other is a little lighter",
  "A guys left side was cut off. Hes all right now"
]


func get_prompt() -> String:
	var word_index = randi() % words.size()

	var word = words[word_index]

	var actual_word = word.to_upper()

	return actual_word
