#!/bin/bash

function print_element() {
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  fi
  
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")

  if [[ -n $ATOMIC_NUMBER ]]
  then
    ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements JOIN properties USING(atomic_number) JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER")
  elif [[ -n $SYMBOL ]]
  then
    ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements JOIN properties USING(atomic_number) JOIN types ON properties.type_id=types.type_id WHERE symbol='$SYMBOL'")
  elif [[ -n $NAME ]]
  then
    ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements JOIN properties USING(atomic_number) JOIN types ON properties.type_id=types.type_id WHERE name='$NAME'")
  else
    echo "I could not find that element in the database."
    return
  fi

  if [[ -n $ELEMENTS ]]
  then
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENTS"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
}
print_element "$1"