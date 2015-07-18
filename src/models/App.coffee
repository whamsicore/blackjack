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
      .on 'dealerBegin', (-> 
        dealerHand.dealerBegin()
        return) , @
    return
    
    # this.get('dealerHand').on('filler', function(){ }, this)


