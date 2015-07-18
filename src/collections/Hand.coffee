class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer, @dealerReveal) -> 

  hit: ->
    if @minScore() < 21 # we busted!
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

    # (blah) -> 
    #   this.return
    #   return

    dealerHit = ()->
      # debugger
      bestScore = @bestScore()

      if bestScore > 21
        @trigger('dealerBusted', @)
      else if bestScore >= 17
        @trigger('dealerDone', @)
      else # less than sweet spot
        @add(@deck.pop())
        setTimeout ( ->
          dealerHit.bind(@)()
          return
        ).bind(@), 1000 
      # console.log(scores, id)
      # if id == 'max'
      #   score = scores[1]
      # else score = scores[0]
      # test = (score)->
      #   console.log(score)
      #   if score > 21
      #     if id == 'max'
      #       console.log('recurse')
      #       dealerHit.bind(@)(scores, 'min')
      #     else
      #       console.log('dealer busted')
      #       @.trigger('dealerBusted', @)
      #   else if score >= 17 and score <= 21
      #     console.log('done compare scores')
      #     @.trigger('dealerDone', @)
      #   else if score < 17
      #     console.log('dealer hits')
      #     dealerHit.bind(@)(scores, 'max')
      #     @add(@deck.pop())
      # test.bind(@)(score)
    
    # dealerHit.bind(@)(@scores(), 'max')
    # if @hasAce()
    #   console.log('has ace')
    #   dealerHit.bind(@)(@scores(), 'max')
    # else
    #   console.log('no ace')
    #   dealerHit.bind(@)(@scores(), 'min')
  
  bestScore: ->
    scores = @scores()
    if scores[1] <= 21
      return scores[1]
    else
      return scores[0]
##    return if ( scores[1] != 0 and scores[1] <= 21 ) then scores[1] else scores[0]  