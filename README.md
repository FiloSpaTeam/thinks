# Think Software

A new way to organize your and your team's workflow.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisities

What things you need to install the software and how to install them

* Cloudinary account for images upload and ENV vars setup, for example you can copy those lines in your ```.bash_profile``` and substitute values. 
```
export CLOUD_NAME_CLOUDINARY=<XXX>
export API_KEY_CLOUDINARY=<YYY>
export API_SECRET_CLOUDINARY=<ZZZ>
```

* ENV var for OTP setup.
```
export THINK_SOFTWARE_OTP="0001100011"
```

### Installing

A step by step series of examples that tell you have to get a development env running:
* Fork project or clone repository
* Enter in project root folder and install gem dependecies with ```bundle install```
* Later you can start your own server with ```rails server```
* You can access your copy to ```localhost:3000```


## Running the tests

Like any Rails app: ```rake test``

Controllers and major function are tested, more deep function are skipped.


## Deployment

The live system is deployed with master branch of https://github.com/FiloSpaTeam/thinks, so any merged branch is automatically deployed to Heroku testing platform: https://thinksoftware.herokuapp.com

## Built With

* Ruby on Rails, main framework
* Lot of plugins that you can find in the Gemfile

* Emacs and [Spacemacs](https://github.com/syl20bnr/spacemacs)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.


## Authors

* **Claudio Maradonna** - *Initial work* - [FiloSpaTeam](https://github.com/FiloSpaTeam)


## License

This project is licensed under the GPLv3 License - see the [COPYING](COPYING) file for details
