# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    
    playerHand = @get('playerHand')
    dealerHand = @get('dealerHand')

    @get 'playerHand' 
      .on 'dealerPlay', (-> 
        dealerHand.dealerPlay()
        return), @
    
    @get 'playerHand'
      .on 'playerBusted', (->
        prompt = confirm('You lose! Play again?')
        if prompt
          @reset()
        return
      ), @
      
    @get 'dealerHand'
      .on 'dealerBusted', (->
        prompt = confirm('You win! Play again?')
        if prompt
          @reset()
        return
      ), @

    @get 'dealerHand'
      .on 'dealerDone', (->
        if playerHand.bestScore() > dealerHand.bestScore()
          prompt = confirm('You win! Play again?')
          if prompt
            @reset()

        else if playerHand.bestScore() == dealerHand.bestScore()
          prompt = confirm('Draw! Play again?')
          if prompt
            @reset()

        else 
          prompt = confirm('You lose! Play again?')
          if prompt
            @reset()
        return), @
  reset: ->
    $('body').html('');
    new AppView(model: new App()).$el.appendTo 'body'

    return


