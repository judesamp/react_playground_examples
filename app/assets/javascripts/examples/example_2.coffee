# Example 2

DOM = React.DOM

############## FormInputWithLabelAndReset #################

FormInputWithLabelAndReset = React.createClass
  displayName: 'FormInputWithLabelAndReset'
  render: ->
    DOM.div
      className: 'form-group'
      DOM.label
        htmlFor: @props.id
        className: 'col-lg-2 control-label'
        @props.labelText
      DOM.div
        className: 'col-lg-10'
        DOM.div
          className: 'input-group'
          DOM.input
            className: 'form-control'
            placeholder: @props.placeholder
            id: @props.id
            value: @props.value
            onChange: (event) ->
              @props.onChange(event.target.value)
          DOM.span
            className: 'input-group-btn'
            DOM.button
              onClick: () =>
                @props.onChange(null)
              className: 'btn btn-default'
              type: 'button'
              DOM.i
                className: 'fa fa-times-magic'
            DOM.button
              onClick: () =>
                @props.onChange("")
              className: 'btn btn-default'
              type: 'button'
              DOM.i
                className: 'fa fa-times-circle'

formInputWithLabelAndReset = React.createFactory(FormInputWithLabelAndReset)

############## DateWithLabel #################

monthName = (monthNumberStartingFromZero) ->
  [
    "January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December"
  ][monthNumberStartingFromZero]

dayName = (date) ->
  dayNameStartingWithSundayZero = date.getDay()
  [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ][dayNameStartingWithSundayZero]

DateWithLabel = React.createClass
  getDefaultProps: ->
    date: new Date()

  onYearChange: (event) ->
    newDate = new Date(
      event.target.value,
      @props.date.getMonth(),
      @props.date.getDate()
    )
    @props.onChange(newDate)

  onMonthChange: (event) ->
    newDate = new Date(
      @props.date.getFullYear(),
      event.target.value,
      @props.date.getDate()
    )
    @props.onChange(newDate)

  onDateChange: (event) ->
    newDate = new Date(
      @props.date.getFullYear()
      @props.date.getMonth(),
      event.target.value,
    )
    @props.onChange(newDate)

  render: ->
    DOM.div
      className: 'form-group'
      DOM.label
        className: 'col-lg-2 control-label'
        "Date"
      DOM.div
        className: 'col-lg-2'
        DOM.select
          className: 'form-control'
          onChange: @onYearChange
          value: @props.date.getFullYear()
          DOM.option(value: year, key: year, year) for year in [2015..2020]
      DOM.div
        className: 'col-lg-3'
        DOM.select
          className: 'form-control'
          onChange: @onMonthChange
          value: @props.date.getMonth()
          DOM.option(value: month, key: month, "#{month+1}-#{monthName(month)}") for month in [0..11]
      DOM.div
        className: 'col-lg-2'
        DOM.select
          className: 'form-control'
          onChange: @onDateChange
          value: @props.date.getDate()
          for day in [1..31]
            date = new Date(
              @props.date.getFullYear(),
              @props.date.getMonth(),
              day
            )
            DOM.option(value: day, key: day, "#{day}-#{dayName(date)}")

dateWithLabel = React.createFactory(DateWithLabel)


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
        date: new Date()
        seoText: null
      }
    }

  computeDefaultSEOText: () ->
    words = @state.meetup.title.toLowerCase().split(/\s+/)
    words.push(monthName(@state.meetup.date.getMonth()))
    words.push(@state.meetup.date.getFullYear().toString())
    words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

  seoChanged: (seoText) ->
    @state.meetup.seoText = seoText
    @forceUpdate()

  dateChanged: (newDate) ->
    @state.meetup.date = newDate
    @forceUpdate()

  titleChanged: (event) ->
    @state.meetup.title = event.target.value
    @forceUpdate()

  descriptionChanged: (event) ->
    @state.meetup.description = event.target.value
    @forceUpdate()

  formSubmitted: (event) ->
    event.preventDefault()
    meetup = @state.meetup

    $.ajax
      url: '/meetups.json'
      type: "POST"
      datatype: 'JSON'
      contentType: 'application/json'
      processData: false
      # data: "#{meetup.date.getFullYear()}-#{meetup.date.getMonth()+1}-#{meetup.date.getDate()}"
      data: JSON.stringify({

        title: @state.meetup.title
        description: @state.meetup.description
        date: @state.meetup.date
        seo: @state.meetup.seoText || @computeDefaultSeoText()

      })

  render: ->
    DOM.form
      onSubmit: @formSubmitted
      className: "form-horizontal"
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
          onChange: @descriptionChanged
          elementType: 'textarea'

        dateWithLabel
          onChange: @dateChanged
          date: @state.meetup.date

        formInputWithLabelAndReset
          id: 'seo'
          value: if @state.meetup.seoText? then @state.meetup.seoText else @computeDefaultSEOText()
          onChange: @seoChanged
          placeHolder: 'SEO Text'
          labelText: 'seo'

        DOM.div
          className: "form-group"
          DOM.div
            className: "col-lg-10 col-lg-offset-2"
            DOM.button
              type: "submit"
              className: "btn btn-primary"
              "Save"

createNewMeetupForm = React.createFactory(CreateNewMeetupForm)

