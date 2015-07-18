class window.CardView extends Backbone.View
  className: 'card'
  attributes: ->
    if @model.get('revealed')
      {"style": "background-image: url("+ "'img/cards/" + @model.get('rankName')+'-'+ @model.get('suitName')+".png')" }
    else
      {"style": "background-image: url('img/card-back.png')"}

  template: _.template ''

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @model.attributes
    @$el.addClass 'covered' unless @model.get 'revealed'

