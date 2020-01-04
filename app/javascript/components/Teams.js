import React from 'react'
import PropTypes from 'prop-types'
import Delete from '../images/delete.png'
import Increase from '../images/increase.png'
import Decrease from '../images/decrease.png'

export default class Teams extends React.Component {
  static propTypes = {
    teams: PropTypes.array.isRequired,
    removeTeam: PropTypes.func.isRequired,
    handleScore: PropTypes.func.isRequired,
    editMode: PropTypes.bool.isRequired
  }

  renderTeams() {
    return this.props.teams.sort((a, b) => a.id - b.id).map(team => {
      return (
        <div key={team.name}>
          <div className='flex items-center'>
            <h4>{team.name}</h4>
            {this.renderDeleteButton(team)}
          </div>
          {this.renderScore(team)}
        </div>
      )
    })
  }

  renderDeleteButton(team) {
    if (this.props.editMode) {
      return <img className='icon mb-2 ml-1' src={Delete} alt='x' onClick={() => this.props.removeTeam(team.id)} />
    }
  }

  renderScore(team) {
    if (this.props.editMode) {
      return (
        <div className='flex items-center'>
          <img className='icon mb-2 mr-1' src={Increase} alt='x' onClick={() => this.props.handleScore(team.id, 'positive', 100)} />
          <h5 className='text-align-center'>{team.score}</h5>
          <img className='icon mb-2 ml-1' src={Decrease} alt='x' onClick={() => this.props.handleScore(team.id, 'negative', 100)} />
        </div>
      )
    } else {
      return <h5 className='text-align-center'>{team.score}</h5>
    }
  }

  render() {
    return (
      <div>
        <div className='teams-container'>
          {this.renderTeams()}
        </div>
      </div>
    )
  }
}
