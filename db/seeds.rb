tournaments = Tournament.create([{ title: 'Tournament #1' }, { title: 'Tournament #2' }])
divisions   = Division.create([{ title: 'Division A' }, { title: 'Division B' }])

divisions.each do |division|
  8.times do
    Team.create(
      title: Faker::Team.name,
      division: division
    )
  end
end
