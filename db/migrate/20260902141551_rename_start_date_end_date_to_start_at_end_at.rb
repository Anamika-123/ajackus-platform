class RenameStartDateEndDateToStartAtEndAt < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :start_date, :start_at
    rename_column :events, :end_date, :end_at
  end
end
