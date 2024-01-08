require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def format_numbers(number)
  number_delimeters = ['-', /\s/, '.']
  formatted_number = number.split(Regexp.union(number_delimeters)).join.delete('()').to_i.to_s
  if formatted_number.length == 10 || (formatted_number.start_with?('1') && formatted_number.length == 11)
    formatted_number
  else
    'BAD NUMBER'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def calculate_frequency(hours)
  hour_frequencies = hours.each_with_object(Hash.new(0)) { |hour, counts| counts[hour] += 1 }
  max_frequency = hour_frequencies.values.max
  hour_frequencies.select { |_, count| count == max_frequency }.keys
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
hours = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  number = row[:homephone]
  registration_date = row[:regdate]
  time = Time.strptime(registration_date.split(' ').last, '%k:%M')
  hours.push(time.hour)

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  numbers = format_numbers(number)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end

p "Popular_Hours: #{calculate_frequency(hours)}"
