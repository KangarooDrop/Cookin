extends Resource

class_name JudgeData

enum JUDGE_DIFFICULTY \
{
	EASY,
	MEDIUM,
	HARD,
	PROFESSOR_SNAPS,
}

####################################################################################################

var name : String = "_no_name"
var desc : String = "_no_desc"
var difficulty : JUDGE_DIFFICULTY = JUDGE_DIFFICULTY.EASY

var flavorsLiked : Array = getFlavorsLiked()
var flavorsDisliked : Array = getFlavorsDisliked()

var tagsLiked : Array = getTagsLiked()
var tagsDisliked : Array = getTagsDisliked()

var ingredientsLiked : Array = getIngredientsLiked()
var ingredientsDisliked : Array = getIngredientsDisliked()

####################################################################################################

func getFlavorsLiked() -> Array:
	return []

func getFlavorsDisliked() -> Array:
	return []

func getTagsLiked() -> Array:
	return []

func getTagsDisliked() -> Array:
	return []

func getIngredientsLiked() -> Array:
	return []

func getIngredientsDisliked() -> Array:
	return []

