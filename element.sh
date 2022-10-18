#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

INPUT=$1

if [[ ! -z $INPUT ]]
then
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$INPUT'")
else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT'")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$INPUT'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
  fi
fi
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
TYPE=$($PSQL "SELECT type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number='$ATOMIC_NUMBER'")
ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
SYMBOL=$(echo $SYMBOL | xargs)
echo The element with atomic number $ATOMIC_NUMBER is $NAME "($SYMBOL)".  It"'"s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
else
  echo Please provide an element as an argument.
fi

