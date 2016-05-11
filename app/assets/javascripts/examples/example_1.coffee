# Example 1 Code

OneTimeClickLink = React.createClass
  getInitialState: ->
    {clicked: false}
  linkClicked: (event) ->
    @setState(clicked: true)
  child: ->
    {
      false: React.DOM.a({href: "javascript:void(0)", onClick: @linkClicked}, 'Click Me')
      true: React.DOM.span({}, 'You clicked the link.')
    }[@state.clicked]
  render: () ->
    React.DOM.div({id: 'one-time-click-link'}, @child())

oneTimeClickLink = React.createFactory(OneTimeClickLink)

$ ->
  el = document.getElementById('simple_link_example')

  if el
    ReactDOM.render(
      oneTimeClickLink(),
      el
    )


  # original code; refactored above
  # virtualDomAfterClick = React.DOM.div(
  #   { id: 'render-me-react-please' },
  #   React.DOM.span(
  #     {},
  #     'You clicked this link'
  #   )
  # )

  # linkClicked = (event) ->
  #   ReactDOM.render(
  #     virtualDomAfterClick,
  #     document.getElementById('app')
  #   )


  # virtualDom = React.DOM.div(
  #   { id: "render-me" },
  #   React.DOM.a(
  #     { href: 'javascript:void(0)', onClick: linkClicked },
  #     'Click Me'
  #   )
  # )

  # ReactDOM.render(
  #   virtualDom,
  #   document.getElementById('app')
  # )
