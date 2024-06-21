#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
  if [[ $YEAR != year ]]
  then
	#team_table
		#get winning_id
		WINNING_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		#if not found
		if [[ -z $WINNING_ID ]]
		then 
			#insert name
      		INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      		if [[ $INSERT_NAME_RESULT == 'INSERT 0 1' ]]
      		then
	    	echo Inserted into teams,$WINNER
      		fi
			#get new winning_id
			WINNING_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		fi
		#get opponent_id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		#if not found
		if [[ -z $OPPONENT_ID ]]
		then 
			#insert name
      		INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      		if [[ $INSERT_NAME_RESULT == 'INSERT 0 1' ]]
      		then
	    	echo Inserted into teams,$OPPONENT
      		fi
    	#get opponent_id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
    	fi
	#games_table
		#insert games
		INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNING_ID,$OPPONENT_ID,$WINNER_GOAL,$OPPONENT_GOAL)")
    	echo Inserted into games, $YEAR $ROUND $WINNING_ID $OPPONENT_ID $WINNER_GOAL $OPPONENT_GOAL
  fi
done