import React from 'react'
import PropTypes from 'prop-types'

export default class JeopardyGame extends React.Component {
  static propTypes = {
    id: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      id: this.props.id,
      categories: this.props.categories,
      categoryName: '',
      categoryId: '',
      showPanelForm: false,
      panelAmmount: '',
      panelQuestion: '',
      panelAnswer: ''
    }
  }

  componentDidMount() {
    const pusher = new Pusher('12e21f086ab8bbad38d2', {
      cluster: 'us2',
      forceTLS: true
    })

    const channel = pusher.subscribe('jeopardy');
    channel.bind('update', (data) => {
      this._fetchGameData()
    })
  }

  _fetchGameData() {
    fetch(`/jeopardy_games/${this.props.id}.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'GET',
    }).then(response => response.json()).then(categories => {
      this.setState((prevState) => {
        return {
          categories: categories,
          showPanelForm: false
        }
      })
    })
  }

  addCategory() {
    fetch(`/jeopardy_games/${this.props.id}/add_category.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
       name: this.state.categoryName
      })
    })
  }

  removeCategory(categoryId) {
    fetch(`/jeopardy_games/${this.props.id}/remove_category.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
       category_id: categoryId
      })
    })
  }

  addPanel() {
    fetch(`/jeopardy_games/${this.props.id}/add_panel.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
        category_id: this.state.categoryId,
        ammount: this.state.panelAmmount,
        question: this.state.panelQuestion,
        answer: this.state.panelAnswer
      })
    })
  }

  showPanelForm(categoryId) {
    this.setState({ showPanelForm: true, categoryId: categoryId })
  }

  renderPanelForm() {
    if (this.state.showPanelForm) {
      return (
        <div className='panel-form-container'>
          <div className='panel-form-inner'>
            <h5 className='mt-2'>Ammount</h5>
            <input className='form-control panel-ammount' type='text' onChange={this.panelAmmountHandler.bind(this)} />
            <h5 className='mt-2'>Question</h5>
            <input className='form-control panel-question' type='text' onChange={this.panelQuestionHandler.bind(this)} />
            <h5 className='mt-2'>Answer</h5>
            <input className='form-control panel-answer' type='text' onChange={this.panelAnswerHandler.bind(this)} />
            <div className='justify-center'>
              <button className='btn btn-outline-info mt-3' onClick={() => this.addPanel()}>add question</button>
            </div>
          </div>
        </div>
      )
    }
  }

  renderCategories() {
    return this.state.categories.map(category => {
      return (
        <div key={category.name} className='card category'>
          <h5 className='text-align-center mt-2'>{category.name}</h5>
          {this.renderPanels(category)}
          <button className='btn btn-outline-secondary m-1' onClick={() => this.showPanelForm(category.id)}>add question</button>
          <button className='btn btn-outline-danger m-1' onClick={() => this.removeCategory(category.id)}>remove</button>
        </div>
      )
    })
  }

  renderPanels(category) {
    if (category.panels.length > 0) {
      return category.panels.map(panel => {
        return (
          <div key={panel.id} className='card question-panel'>
            <h5 className='text-align-center mt-1 panel-ammount'>{panel.ammount}</h5>
          </div>
        )
      })
    }
  }

  categoryNameInputHandler(event) {
    this.setState({ categoryName: event.target.value });
  }

  panelAmmountHandler(event) {
    this.setState({ panelAmmount: event.target.value });
  }

  panelQuestionHandler(event) {
    this.setState({ panelQuestion: event.target.value });
  }

  panelAnswerHandler(event) {
    this.setState({ panelAnswer: event.target.value });
  }

  render() {
    return (
      <div className='flex justify-center p-2'>
        {this.renderPanelForm()}
        {this.renderCategories()}
        <form className='flex-column'>
          <input className='form-control' type='text' onChange={this.categoryNameInputHandler.bind(this)}/>
          <button className='btn btn-outline-info' onClick={() => this.addCategory()}>add category</button>
        </form>
      </div>
    )
  }
}
