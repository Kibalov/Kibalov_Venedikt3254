package player

import (
	"fmt"
	"math/rand"
)

type Character struct {
	Health    int
	Respect   int
	HoleLenth int
	Weight    int
}

func (ch *Character) SetBaseStats() {
	ch.Health = 100
	ch.Respect = 20
	ch.HoleLenth = 10
	ch.Weight = 30
}

func (ch *Character) IsCharacterDead() bool {
	return ch.Health <= 0 || ch.Respect <= 0 || ch.HoleLenth <= 0 || ch.Weight <= 0
}

func (ch *Character) PrintStats() {
	fmt.Println("Health:", ch.Health)
	fmt.Println("Respect:", ch.Respect)
	fmt.Println("HoleLenth:", ch.HoleLenth)
	fmt.Println("Weight:", ch.Weight)
}

func (ch *Character) Night() {
	ch.Health += 20
	ch.Respect -= 5
	ch.HoleLenth -= 2
	ch.Weight -= 5
}

func (ch *Character) DigIntensive() {
	ch.Health -= 30
	ch.HoleLenth += 5
}

func (ch *Character) DigNormal() {
	ch.Health -= 10
	ch.HoleLenth += 2
}

func (ch *Character) EatWitheredGrass() {
	ch.Health += 10
	ch.Weight += 15
}

func (ch *Character) EatGreenGrass() {
	if ch.Respect < 30 {
		ch.Health -= 30
	} else {
		ch.Health += 30
		ch.Weight += 30
	}
}

func (ch *Character) SleepAllDay() {
	ch.Night()
}

func (ch *Character) FightWithEnemy(EnemyWeight int) {
	if rand.Intn(ch.Weight+EnemyWeight) <= ch.Weight {
		if ch.Weight < EnemyWeight {
			ch.Respect += 10 + (EnemyWeight-ch.Weight)*2
		} else {
			ch.Respect += EnemyWeight / 6
		}
		fmt.Println("You won the fight")
	} else {
		ch.Health -= EnemyWeight/2 - 5
		fmt.Println("You lost the fight")
	}
}
