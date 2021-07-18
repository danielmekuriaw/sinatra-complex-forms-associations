class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do 
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do 
    @pet = Pet.create(name: params["pet_name"])
    @pet.save

    if params.size == 3
      @owner = Owner.find(params["pet"]["owner_ids"].first)
    else
      @owner = Owner.create(name: params["owner_name"])
    end

    @owner.save
    @owner.pets << @pet

    redirect "pets/#{@pet.id}"
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  get '/pets/:id/edit' do 
    @pet = Pet.find(params[:id])
    @owners = Owner.all
    erb :'/pets/edit'
  end

  patch '/pets/:id' do 
    puts params

      @pet = Pet.find_by(id: params["id"])
      @pet.name = params["pet_name"]
      @pet.save

      #@owner = Owner.find_by(id: params["pet"]["owner_id"].first)
      #puts "OWNER"
      #puts params["owner"]["name"].class

      if params["owner"]["name"] == ""
        puts params["pet"]["owner_id"].first
        @owner = Owner.find_by(id: params["pet"]["owner_id"].first)
        @owner.pets << @pet
        @owner.save
      else
        @owner = Owner.create(name: params["owner"]["name"])
        @owner.pets << @pet
        @owner.save
      end

      redirect "pets/#{@pet.id}"
  end
end