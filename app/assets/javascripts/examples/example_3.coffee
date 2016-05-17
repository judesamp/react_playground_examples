window.Blogpost = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired
    date: React.PropTypes.any.isRequired
    type: React.PropTypes.oneOf(['Post', 'Ad'])
    content: React.PropTypes.any.isRequired

  render: -> React.DOM.div null,
    React.DOM.div null,
      @props.name
    React.DOM.div null,
      "Type: #{@props.type}"
    React.DOM.div null,
      "Date: #{@props.date}"
    React.DOM.div null,
      @props.content

blogpost = React.createFactory(Blogpost)
