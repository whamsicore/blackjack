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
      # scores = @scores

      # has no ace
        if @minScore() < 17
          # we hit()
          @add(@deck.pop())
          # @last()
          setTimeout(subroutine.bind(@), 1000)
          return
        # else
        else if @minScore() > 21
          # stop and check but
          @.trigger('dealerBusted', @)
        else
          @.trigger('dealerDone', @)

      # else if hand has ace then check max
        # if max is bust and min < 17
          # hit
        # if min between 17 and 21
          # stop





    subroutine.bind(@)()
    return
  
  bestScore: ->
    scores = @scores()
    return if ( scores[1] != 0 and scores[1] <= 21 ) then scores[1] else scores[0]
    