# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    
    playerHand = @get('playerHand')
    dealerHand = @get('dealerHand')

    # func: when player clicks 'stand', we detect the trigger, and set off the dealer
    @get 'playerHand' 
      .on 'dealerPlay', (-> 
        dealerHand.dealerPlay()
        return), @
    
    @get 'playerHand'
      .on 'playerBusted', (->
        alert('you lose!')
        return), @

    @get 'dealerHand'
      .on 'dealerBusted', (->
        alert('you win!')
        return), @

    @get 'dealerHand'
      .on 'dealerDone', (->
        # console.log('scores', playerHand.bestScore())
        if playerHand.bestScore() > dealerHand.bestScore()
          alert('you win!')
        else if playerHand.bestScore() == dealerHand.bestScore()
          alert('draw')
        else alert('you lose!')
        return), @

    return


