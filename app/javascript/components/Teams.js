import React from 'react'
import PropTypes from 'prop-types'

export default class Teams extends React.Component {
  static propTypes = {
    teams: PropTypes.array.isRequired,
    removeTeam: PropTypes.func.isRequired
  }

  renderTeams() {
    return this.props.teams.sort((a, b) => a.id - b.id).map(team => {
      return (
        <div key={team.name}>
          <button className='btn remove-player' onClick={() => this.props.removeTeam(team.id)}>{team.name}</button>
          <h5 className='text-align-center'>{team.score}</h5>
        </div>
      )
    })
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
