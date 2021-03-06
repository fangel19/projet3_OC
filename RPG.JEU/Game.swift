//
//  game.swift
//  RPG.JEU
//
//  Created by angelique fourny on 07/05/2020.
//  Copyright © 2020 angelique fourny. All rights reserved.
//
import Foundation

// Creation of the Game class

class Game {
    
    private var player1: Player?
    private var player2: Player?
    private var playerTurn: Player?
    private var playerNotTurn: Player?
    
    private var isPlayerOneTurn: Bool = true
    private var hasAlreadyChoiceMagician: Bool = false
    
    private var playerTurnSelectedCharacter: Character?
    private var playerNotTurnSelectedCharacter: Character?
    
    var numberRound = 0
    
    
    // Creation of the game application
    
    func intro() {
        print("Welcome to the game !")
    }
    
    //Choice of 3 characters per team
    
    func choiceTeam(name: String) -> Character {
        
        var teamnumber = 0
        
        //You have a choice with three character : Warrior, Magician, Zombie
        //You can choose the magician only once
        
        !hasAlreadyChoiceMagician ? print("choice a characters"
            + "\n1. The Warrior with 200 life points and 53 attack point"
            + "\n2. The Magician with 250 life points and 50 heal power"
            + "\n3. The Zombie with 150 life points and 63 attack point") : print("choice a characters\n\n (There are no magician because you've already choice a Magician)\n"
                + "\n1. The Warrior with 200 life points and 53 attack point"
                + "\n3. The Zombie with 150 life points and 63 attack point")
        
        repeat {
            let team = Tools.shared.getInputInt()
            switch team {
            case 1:
                teamnumber += 1
                let character = Warrior(name: name)
                print(character.name, character.weapon.name, character.weapon.damage)
                return character
                
            // "where" solution allows us to check if a magician is chosen.
            // In this case it will be deleted from the choice list
            case 2 where !hasAlreadyChoiceMagician:
                teamnumber += 1
                hasAlreadyChoiceMagician = true
                let character = Magician(name: name)
                print(character.name, character.weapon.name, character.weapon.damage)
                return character
                
            case 3:
                teamnumber += 1
                let character = Zombie(name: name)
                print(character.name, character.weapon.name, character.weapon.damage)
                return character
                
            default:
                if !hasAlreadyChoiceMagician && team < 1 || team > 3 {
                    print("You did not choose a character")
                } else {
                    print("It's not possible to have 2 magician per team")
                }
                
            }
            
            // Repeat until the user has chosen a character
            
        } while teamnumber < 1
        
    }
    
    //function that asks a user to give a name to their characters
    
    func askNameOfCharacter() {
        //variable for choice of name in string array
        //variable that returns an array of characters
        
        var tabNamesOfCharacters: [String] = [String]()
        var tabChoiceOfCharacter: [Character] = [Character]()
        
        repeat {
            //player 1 choice a character in fonction choiceTeam
            
            print("\n Player 1 -> Choice name of your character \(tabNamesOfCharacters.count + 1) :")
            var check: Bool = false
            
            repeat {
                let name = Tools.shared.getInputString()
                if !tabNamesOfCharacters.contains(name) {
                    check = true
                    tabChoiceOfCharacter.append(choiceTeam(name: name))
                    tabNamesOfCharacters.append(name)
                } else {
                    print("\(name) is already taken !")
                }
            } while check == false
            
        } while tabNamesOfCharacters.count != 3
        print(tabNamesOfCharacters[0], tabChoiceOfCharacter[0].type, tabNamesOfCharacters[1], tabChoiceOfCharacter[1].type, tabChoiceOfCharacter[2].type, tabNamesOfCharacters[2])
        hasAlreadyChoiceMagician = false
        player1 = Player(character: [tabChoiceOfCharacter[0],  tabChoiceOfCharacter[1], tabChoiceOfCharacter[2]])
        
        
        
        repeat {
            //player 2 choice a character in fonction choiceTeam
            
            print("\n Player 2 -> Choice name of your character  \(tabNamesOfCharacters.count - 2) : ")
            var check: Bool = false
            
            repeat {
                let name = Tools.shared.getInputString()
                if !tabNamesOfCharacters.contains(name) {
                    check = true
                    tabChoiceOfCharacter.append(choiceTeam(name: name))
                    tabNamesOfCharacters.append(name)
                } else {
                    print("\(name) is already taken!\n")
                }
            } while check == false
            
        } while tabNamesOfCharacters.count != 6
        print(tabNamesOfCharacters[3], tabChoiceOfCharacter[3], tabNamesOfCharacters[4], tabChoiceOfCharacter[4], tabChoiceOfCharacter[5], tabNamesOfCharacters[5])
        hasAlreadyChoiceMagician = false
        player2 = Player(character: [tabChoiceOfCharacter[3],  tabChoiceOfCharacter[4], tabChoiceOfCharacter[5]])
    }
    
    
    // function which asks the player to choose an attacker and an enemy in each team
    
    func selectCharacter() {
        
        playerTurn = (isPlayerOneTurn) ? player1 : player2
        playerNotTurn = (isPlayerOneTurn) ? player2 : player1
        
        
        guard let playerTurn = playerTurn else { return }
        guard let playerNotTurn = playerNotTurn else { return }
        
        
        if isPlayerOneTurn {
            print("\nPlayer 1: Choose a character :")
        } else {
            print("\nPlayer 2: Choose a character :")
        }
        
        playerTurn.printCharacterInLife()
        
        print("What's your choice ? (please, pick a number for your attacker) :")
        
        choiceAttacker()
        
        
        guard let playerTurnSelectedCharacter = playerTurnSelectedCharacter else {
            return
        }
        if playerTurnSelectedCharacter.type != "Magician" {
            
            
            playerNotTurn.printCharacterInLife()
            
            print("What's your choice ? (please, pick a number for your ennemy) :")
            
            choiceEnnemy()
            
            //Surprise Chest could appear
            surpriseChest()
            playerTurnSelectedCharacter.attack(target: playerNotTurnSelectedCharacter!, player: playerNotTurn)
            
            // But if he chooses the magician, he will have to choose who to give life to
            // this coding allows later to add characters to the team without creating a bug
            
        } else {
            var index: Int = 0
            let rangeMax: Int = playerTurn.characterInLife.count - 1
            let rangeMin: Int = playerTurn.characterInLife.count - (playerTurn.characterInLife.count - 1) - 1
            print("Witch character you want to heal ?")
            playerTurn.printCharacterInLife()
            
            repeat {
                index = Tools.shared.getInputInt() - 1
                if index < rangeMin || index > rangeMax {
                    print("Number should be between \(rangeMin + 1) and \(rangeMax + 1)")
                }
            }
                while index < rangeMin || index > rangeMax
            playerTurnSelectedCharacter.heal(target: playerTurn.characterInLife[index])
            
        }
        numberRound += 1
        
        isPlayerOneTurn.toggle()
        if !isPlayerOneTurn {
            Tools.shared.increaseTurn()
        }
        if !(playerTurn.numberOfCharacterDies == 3) && !(playerNotTurn.numberOfCharacterDies == 3) {
            launchTurn()
            
        } else {
            statsGame()
        }
    }
    
    // function to choose an attacker
    func choiceAttacker() {
        
        var index: Int = Int()
        guard let playerTurn = playerTurn else { return }
        let rangMax: Int = playerTurn.characterInLife.count - 1
        let rangMin: Int = playerTurn.characterInLife.count - (playerTurn.characterInLife.count - 1) - 1
        
        repeat {
            index = Tools.shared.getInputInt() - 1
            if index < rangMin || index > rangMax {
                print("Number should be \(rangMin + 1) and \(rangMax + 1)")
            }
            
        } while index < rangMin || index > rangMax
        playerTurnSelectedCharacter = playerTurn.characterInLife[index]
    }
    
    // function to choose an ennemy
    func choiceEnnemy() {
        
        var index: Int = Int()
        guard let playerNotTurn = playerNotTurn else { return }
        let rangMax: Int = playerNotTurn.characterInLife.count - 1
        let rangMin: Int = playerNotTurn.characterInLife.count - (playerNotTurn.characterInLife.count - 1) - 1
        
        repeat {
            index = Tools.shared.getInputInt() - 1
            if index < rangMin || index > rangMax {
                print("Number should be \(rangMin + 1) and \(rangMax + 1)")
            }
            
        } while index < rangMin || index > rangMax
        playerNotTurnSelectedCharacter = playerNotTurn.characterInLife[index]
    }
    
    
    // function that brings up a random chest
    // which replaces the attacker's weapon
    
    func surpriseChest() {
        guard let selectCharacter = playerTurnSelectedCharacter else { return }
        
        let randomChest = Int.random(in: 1...8)
        if randomChest == 4 {
            let chest = Chest()
            selectCharacter.weapon = chest.chestmystery()
            
            print("WEAPON MISTERY, \(selectCharacter.weapon.name), \(selectCharacter.weapon.damage)")
        }
    }
    
    
    func launchTurn() {
        selectCharacter()
    }
    
    
    
    func statsGame() {
        // Function "statsGame" that displays the winner as well as the game stats.
        // if player 1 does not have a living character, the winner is player 2
        // print("The team is dead !")
        isPlayerOneTurn ? print("\nThe player 2 Wins") : print("\nThe player 1 Wins")    
        
        // check that it is player 2
        guard let player2 = player2 else { return }
        if player2.characterInLife.count > 0 {
            print("\nPlayer 2 character in life : ")
            player2.printCharacterInLife()
        }
        
        if player2.characterDead.count > 0 {
            print("\nPlayer 2 character deads : ")
            player2.printCharacterDead()
        }
        
        // check that it is player 1
        guard let player1 = player1 else { return }
        if player1.characterInLife.count > 0 {
            print("\nPlayer 1 character in life : ")
            player1.printCharacterInLife()
        }
        
        if player1.characterDead.count > 0 {
            print("\nPlayer 1 character deads : ")
            player1.printCharacterDead()
        }
        print("The party is over")
        
    }
    
    
}
