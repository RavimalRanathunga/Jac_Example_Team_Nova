import random

class Game:
    
    def __init__(self,attempts):
        self.attempts = attempts
    
    def play(self):
        raise NotImplementedError("Subclasses must implement this mehthod")


class GuessTheNumberGame(Game):
    
    def __init__(self, attempts=10):
        super().__init__(attempts)
        self.correct_number = random.randint(1,10)
    
    def play(self):
        while (self.attempts>0):
            guess = input("guess a number between 1 to 10: ")
            if (guess.isdigit()):
                if (self.process_guess(int(guess))):
                    print("guess is correct")
                    return
            else:
                print("not a valid number") 
            
            self.attempts -= 1
            
            if (self.attempts > 0):
                print(f"you have {self.attempts} attempts left.")
    
    def process_guess(self, guess):
        if (guess > self.correct_number):
            print("too high!")
        elif (guess < self.correct_number):
            print("too low!")
        
        else:
            return True
        return False

def main():

    game = GuessTheNumberGame()
    game.play()


if (__name__ == "__main__"):
    main()