# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

require 'spec_helper'

describe EventsController do

  context 'event_course' do
    let(:group) { groups(:bund) }
    let(:date)  { { label: 'foo', start_at_date: Date.today, finish_at_date: Date.today } }
    let(:event) { assigns(:event) }

    let(:event_attrs) { { group_ids: [group.id], name: 'foo',
                          kind_id: Event::Kind.where(short_name: 'LPK').first.id,
                          dates_attributes: [date], type: 'Event::Course' } }


    before { sign_in(people(:bulei)) }

    it 'creates new event course with dates, advisor' do
      post :create, event: event_attrs.merge(contact_id: Person.first, advisor_id: Person.last), group_id: group.id
      expect(event.dates).to have(1).item
      expect(event.dates.first).to be_persisted
      expect(event.contact).to eq Person.first
      expect(event.advisor).to eq Person.last
    end

    it 'creates new event course without contact, advisor' do
      post :create, event: event_attrs.merge(contact_id: '', advisor_id: ''), group_id: group.id

      expect(event.contact).not_to be_present
      expect(event.advisor).not_to be_present
      expect(event).to be_persisted
    end

  end
end
