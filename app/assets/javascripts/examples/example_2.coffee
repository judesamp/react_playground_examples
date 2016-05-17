# Example 2

DOM = React.DOM

############## Separator #################

Separator = React.createClass
  displayName: 'Separator'
  render: () ->
    children = []
    for child, i in @props.children
      children.push( child )
      if i < @props.children.length - 1
        children.push(
          DOM.div
            key: "separator-#{i}"
            className: 'col-lg-offset-2 col-lg-10'
            DOM.hr
              className: 'form-input-separator'
        )
    DOM.div(null, children)

separator = React.createFactory(Separator)

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
        className: "col-lg-10" + { true: 'has-warning', false: '' }[!!@props.warning]
        @warning()
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

  warning: ->
    return null unless @props.warning
    DOM.label
      className: 'control-label'
      htmlFor: @props.id
      @props.warning

formInputWithLabel = React.createFactory(FormInputWithLabel)

############## CreateNewMeetupForm #################

window.CreateNewMeetupForm = React.createClass
  displayName: 'CreateNewMeetupForm'

  getInitialState: ->
    {
      meetup: {
        title: "",
        description: "",
        date: new Date(),
        seoText: null,
        guests: [""],
        technology: @props.technologies[0].name
      },

      warnings: {
        title: null
      }
    }

  computeDefaultSEOText: () ->
    words = @state.meetup.title.toLowerCase().split(/\s+/)
    words.push(monthName(@state.meetup.date.getMonth()))
    words.push(@state.meetup.date.getFullYear().toString())
    words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

  technologyChanged: (event) ->
    @state.meetup.technology = event.target.value
    @forceUpdate()

  seoChanged: (seoText) ->
    @state.meetup.seoText = seoText
    @forceUpdate()

  guestEmailChanged: (number, event) ->
    guests = @state.meetup.guests
    guests[number] = event.target.value

    lastEmail           = guests[guests.length - 1]
    penultimateEmail    = guests[guests.length - 2]

    if (lastEmail != "")
      guests.push("")
    if guests.length >= 2 & lastEmail == "" && penultimateEmail == ""
      guests.pop()

    @forceUpdate()

  dateChanged: (newDate) ->
    @state.meetup.date = newDate
    @forceUpdate()

  titleChanged: (event) ->
    @state.meetup.title = event.target.value
    @validateTitle()
    @forceUpdate()

  descriptionChanged: (event) ->
    @state.meetup.description = event.target.value
    @forceUpdate()

  validateTitle: () ->
    @state.warnings.title = if /\S/.test(@state.meetup.title) then null else "Cannot be blank"

  formSubmitted: (event) ->
    event.preventDefault()
    meetup = @state.meetup

    @validateTitle()
    @forceUpdate()

    for own key of meetup
      reutrn if @state.warnings[key]

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
        seo: @state.meetup.seoText || @computeDefaultSEOText()
        guests: @state.meetup.guests
        technology: @state.meetup.technology

      })
      success: (data, textStatus, jqXHR) ->
        alert('okay, this is ugly, but the meetup was successfully saved. In real application, would clear the the form and respond prettily :)')
      error: (error) ->
        console.log(error)


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
          warning: @state.warnings.title

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

        DOM.div
          className: 'form-group'
          DOM.label
            htmlFor: 'technology'
            className: 'col-lg-2 control-label'
            "Technology"
          DOM.div
            className: 'col-lg-10'
            DOM.select
              className: 'form-control'
              onChange: @technologyChanged
              value: @state.meetup.technology
              DOM.option(value: tech.name, key: tech.id, tech.name) for tech in @props.technologies

        formInputWithLabelAndReset
          id: 'seo'
          value: if @state.meetup.seoText? then @state.meetup.seoText else @computeDefaultSEOText()
          onChange: @seoChanged
          placeHolder: 'SEO Text'
          labelText: 'seo'

        DOM.fieldset null,
          DOM.legend null, "Guests"
          separator null,
            for guest, n in @state.meetup.guests
              ((i) =>
                formInputWithLabel
                  id: "email"
                  key: "guest-#{i}"
                  value: guest
                  onChange: (event) =>
                    @guestEmailChanged(i, event)
                  placeholder: "Email address of an invitee"
                  labelText: "Email"
                  elementType: 'input'
              )(n)

        DOM.div
          className: "form-group"
          DOM.div
            className: "col-lg-10 col-lg-offset-2"
            DOM.button
              type: "submit"
              className: "btn btn-primary"
              "Save"

createNewMeetupForm = React.createFactory(CreateNewMeetupForm)
