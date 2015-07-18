class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) -> 
    # bob = []
    console.log(array)

  hit: ->
    # if scores < 21
    if @minScore() < 21 # we busted!
      @add(@deck.pop()) #add new card to hand
      if @minScore()>21
        @.trigger('playerBusted', @)
      @last()
      # do nothing
    # else
    # else do nothing

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]
  
  stand: ->
    @trigger 'dealerBegin', @;

  dealerBegin: ->
    console.log('Dealer play')
    # show hand
    @models[0].flip()
    subroutine = ->
      if @minScore() < 17
        # we hit()
        @add(@deck.pop())
        # @last()
        setTimeout(subroutine.bind(@), 1000)
        return
      # else
      else # >17
        # stop and check but
        alert('Dealer Busted!') if @minScore() > 21
    subroutine.bind(@)()
    return  
  




    # check again (because response should be instantaneous. e.g. bust). 
    # if true, call dealerBegin() in 1000 ms. If false, give appropriate response



