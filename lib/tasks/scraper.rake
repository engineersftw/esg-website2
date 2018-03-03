namespace :scraper do
  desc 'Run Scrapers needed by the app'
  task run: :environment do
    default_task = "scraper:#{ENV['DEFAULT_SCRAPER']}"
    Rake::Task[default_task].invoke
  end

  desc 'WebuildSG Events'
  task webuildsg: :environment do
    Rails.logger.info 'Starting scraper for WebuildSG'
    events = WebuildsgEventsService.new.scrape
    Rails.logger.info "Found #{events.count} events:"
    events.each do |e|
      Rails.logger.info "Saving: #{e.title}"
      e.save
    end
    Rails.logger.info 'Done scraping.'
  end
end
