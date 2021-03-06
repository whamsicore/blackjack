class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer, @dealerReveal) -> 

  hit: ->
    if @minScore() < 21
      @add(@deck.pop()) #add new card to hand
      if @minScore()>21
        @.trigger('playerBusted', @)
      @last()

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
    @trigger 'dealerPlay', @;

  dealerPlay: ->
    # show hand
    @dealerReveal = true
    @models[0].flip()

    setTimeout ( ->
      dealerHit.bind(@)()
      return
    ).bind(@), 1000

    dealerHit = ()->
      bestScore = @bestScore()
pllplp        @trigger('dealerBusted', @)
      else if bestScore >= 17
        @trigger('dealerDone', @)
      else # less than sweet spot
        @add(@deck.pop())
        setTimeout ( ->
          dealerHit.bind(@)()
          return
        ).bind(@), 1000
  
  bestScore: ->
    scores = @scores()
    if scores[1] <= 21
      return scores[1]
    else
      return scores[0]
##    return if ( scores[1] != 0 and scores[1] <= 21 ) then scores[1] else scores[0]  