#!/bin/bash
CARDS_FILE="$HOME/.flashcards/.db"
curr_card=0
question_box_width=40
question_box_height=5
seperation_delimiter="$"
correct_count=0

do_flashcard() {
	line="$1"

	# Seperate flashcard values
	question=$(echo "$line" | cut -d "$seperation_delimiter" -f 1)
	answer=$(echo "$line" | cut -d "$seperation_delimiter" -f 2)

	question_length=${#question}
	
	final_string=""
	outline=""
	outline=$(printf "%*s" $((question_box_width)) "" | tr ' ' '-')
	final_string="$outline"
	
	# Create box
	for ((i = 0 ; i < question_box_height; i++)); do
		num_spaces=$((question_box_width-2))
		
		# Insert the question value and calculate midpoint
		if [[ $i == $(($question_box_height/2)) ]]; then
			((num_spaces = (num_spaces - question_length)/2))

			# Add a space if odd length
			if ((question_length % 2 != 0)); then
				right_spaces=$((num_spaces + 1))
			else
				right_spaces=$num_spaces
			fi

			middle_line="|$(printf "%*s" $((num_spaces)) "")$question$(printf "%*s" $((right_spaces)) "")|"
		else
			middle_line="|$(printf "%*s" $num_spaces "")|"
		fi
		final_string+="\n$middle_line"
	done
	
	# Ouotput final string
	final_string+="\n$outline"
	echo -e "$final_string"

	# Get answer
	read -p "Answer: " ans < /dev/tty
	echo "Correct Answer: $answer"

	if [[ $ans == $answer ]]; then
		((correct_count++))
		echo "You got it right! $correct_count/$curr_card"
	fi

	read -p "Press (ENT) to go to next card" < /dev/tty
}

while read -r line; do
	((curr_card++))
	clear
	echo "Card nr: $curr_card"
	do_flashcard "$line"
done < $CARDS_FILE

echo "You got $correct_count/$curr_card"
