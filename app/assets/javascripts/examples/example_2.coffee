# Example 2

DOM = React.DOM


############## FormInputWithLabel #################

FormInputWithLabel = React.createClass
  displayName: "FormInputWithLabel"
  render: ->
    DOM.div
      className: "form-group"
      DOM.label
        htmlFor: @props.id
        className: "col-lg-2 control-label"
        @props.labelText
      DOM.div
        className: "col-lg-10"
        DOM[@props.elementType]
          className: "form-control"
          placeholder: @props.placeholder
          id: @props.id
          type: @tagType()
          value: @props.value
          onChange: @props.onChange
  tagType: ->
    {
      "input": @props.inputType,
      "textArea": null
    }[@props.ElementType]

formInputWithLabel = React.createFactory(FormInputWithLabel)


############## CreateNewMeetupForm #################

window.CreateNewMeetupForm = React.createClass
  displayName: 'CreateNewMeetupForm'

  getInitialState: ->
    {
      meetup: {
        title: "",
        description: ""
      }
    }

  titleChanged: (event) ->
    @state.meetup.title = event.target.value
    @forceUpdate()

  descriptionChanged: (event) ->
    @state.meetup.description = event.target.value
    @forceUpdate()

  render: ->
    DOM.form
      className: "form-horizontal"
      method: 'post'
      action: '/meetups'
      DOM.fieldset null
        DOM.legend null, 'New Meetup'

        formInputWithLabel
          id: 'title'
          labelText: 'Title'
          placeHolder: 'Enter Title Here'
          value: @state.meetup.title
          onChange: @titleChanged
          elementType: 'input'

        formInputWithLabel
          id: 'description'
          labelText: 'Description'
          placeHolder: 'Enter Description Here'
          value: @state.meetup.description
          onChange: @titleChanged
          elementType: 'textarea'

        DOM.div
          className: "form-group"
          DOM.div
            className: "col-lg-10 col-lg-offset-2"
            DOM.button
              type: "submit"
              className: "btn btn-primary"
              "Save"

createNewMeetupForm = React.createFactory(CreateNewMeetupForm)

