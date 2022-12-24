package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/Kibalov/Kibalov_Venedikt3254/console_game/player"
)

func main() {
	fmt.Println("Welcome to the game \"Rabbit in the hole\"")
	fmt.Println("You are a rabbit, who is digging a hole in the ground. You have to survive as long as possible. You can dig, eat, figth, rest, (exit)? (Write \"stats\" to see your stats)")
	fmt.Println("PS: copilot is the best :)")
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	fmt.Println("Your current stats:")
	rabbit.PrintStats()

	for !rabbit.IsCharacterDead() {
		fmt.Println()
		fmt.Println("You slept well, day is coming")
		rabbit.PrintStats()
		fmt.Println("What do you want to do today: dig, eat, figth, rest, (exit)? (Write \"stats\" to see your stats)")
		scanner := bufio.NewScanner(os.Stdin)
		scanner.Scan()
		input := scanner.Text()

		switch input {
		case "dig":
			fmt.Println("How do you want to dig: intensive, normal?")
			scanner.Scan()
			input := scanner.Text()
			switch input {
			case "intensive":
				rabbit.DigIntensive()
			case "normal":
				rabbit.DigNormal()
			default:
				fmt.Println("Wrong input, miss all day")
			}
		case "eat":
			fmt.Println("What do you want to eat: withered grass, green grass?")
			scanner.Scan()
			input := scanner.Text()
			switch input {
			case "withered grass":
				rabbit.EatWitheredGrass()
			case "green grass":
				rabbit.EatGreenGrass()
			default:
				fmt.Println("Wrong input, miss all day")
			}
		case "fight":
			fmt.Println("How big iss your enemy: small, normal, big?")
			scanner.Scan()
			input := scanner.Text()
			switch input {
			case "small":
				rabbit.FightWithEnemy(30)
			case "normal":
				rabbit.FightWithEnemy(50)
			case "big":
				rabbit.FightWithEnemy(70)
			default:
				fmt.Println("Wrong input, miss all day")
			}

		case "rest":
			rabbit.SleepAllDay()
		case "stats":
			rabbit.PrintStats()
		case "exit":
			os.Exit(0)
		default:
			fmt.Println("Wrong input, miss all day")
		}

		fmt.Println("Night is coming")

		if rabbit.Respect > 100 {
			fmt.Println("Congratulations! You are winner!")
			os.Exit(0)
		}
		rabbit.Night()

	}
	fmt.Println("You are dead")

}
