-- Seed Branches
insert into branches (id, name, address, phone, email, map_url, image) values
('downtown', 'Downtown Medical Center', '123 Main Street, Downtown, City 10001', '+1 (555) 123-4567', 'downtown@medicareplus.com', 'https://maps.google.com', 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800'),
('westside', 'Westside Health Campus', '456 Oak Avenue, Westside, City 10002', '+1 (555) 234-5678', 'westside@medicareplus.com', 'https://maps.google.com', 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800'),
('eastside', 'Eastside Community Hospital', '789 Pine Road, Eastside, City 10003', '+1 (555) 345-6789', 'eastside@medicareplus.com', 'https://maps.google.com', 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=800'),
('north', 'North Specialty Clinic', '321 Elm Boulevard, North District, City 10004', '+1 (555) 456-7890', 'north@medicareplus.com', 'https://maps.google.com', 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=800')
on conflict (id) do nothing;

-- Seed Services
insert into services (id, title, description, full_description, color, bg_color, features, icon_name) values
('mr-service', 'নিরাপদ এম আর (Safe M.R)', 'আমাদের ক্লিনিকে অভিজ্ঞ ও প্রশিক্ষিত স্বাস্থ্যকর্মীর মাধ্যমে নিরাপদ, গোপনীয় ও স্বাস্থ্যসম্মত এম আর সেবা প্রদান করা হয়।', 'আধুনিক পদ্ধতি ও পরিষ্কার পরিবেশে করা হওয়ায় ঝুঁকি অত্যন্ত কম এবং রোগীর স্বাস্থ্যের সর্বোচ্চ যত্ন নিশ্চিত করা হয়।', 'text-red-500', 'bg-red-50', ARRAY['মাসিক নিয়মিত করণ (Menstrual Regulation)', 'গর্ভপাত পরবর্তী সেবা (PAC)', 'এম আর / ডি এন্ড সি (জটিলতা মুক্ত)', 'জরায়ুতে রিং পরামর্শ', 'এম আর / প্যাক ফলোআপ (৩০ দিনের মধ্যে)'], 'Activity'),
('maternity', 'নিরাপদ মাতৃত্ব (Safe Motherhood)', 'আমাদের ক্লিনিকে রয়েছে নিরাপদ ও স্বাস্থ্যসম্মত নরমাল ডেলিভারি সেবা।', 'প্রশিক্ষিত মিডওয়াইফ ও স্বাস্থ্যকর্মীদের মাধ্যমে মা ও নবজাতকের সর্বোচ্চ নিরাপত্তা নিশ্চিত করা হয়।', 'text-pink-500', 'bg-pink-50', ARRAY['ডেলিভারি (নরমাল)', 'ডেলিভারি (সাইড সিজার)', 'গর্ভবতী মায়ের চেকআপ ও প্রসবপূর্ব সেবা'], 'Baby'),
('family-planning', 'পরিবার পরিকল্পনা সেবা', 'নারী ও পুরুষের জন্য দীর্ঘমেয়াদি ও স্থায়ী পরিবার পরিকল্পনা পদ্ধতি নিয়ে পরামর্শ ও সেবা।', 'নিরাপদ ও কার্যকর সরকারি অনুমোদিত জন্মনিয়ন্ত্রণ পদ্ধতি।', 'text-blue-500', 'bg-blue-50', ARRAY['খাবার বড়ি (সরকারি-প্রতি পাতা)', 'কনডম (১০ পিস)', 'ইমার্জেন্সি কনট্রাসেপটিভ পিল', 'ইনজেকশন / ডিপো', 'আইইউডি / ইমপ্লান্ট / স্থায়ী পদ্ধতি'], 'Pill'),
('reproductive-health', 'প্রজনন ও সাধারণ স্বাস্থ্য', 'মাসিক সমস্যা, বন্ধ্যাত্ব, হরমোনজনিত সমস্যা এবং সাধারণ রোগের চিকিৎসা ও পরামর্শ।', 'যৌনবাহিত সংক্রমণ প্রতিরোধ ও চিকিৎসার জন্য গোপনীয় ও নিরাপদ সেবা।', 'text-teal-500', 'bg-teal-50', ARRAY['প্রজনন স্বাস্থ্য কনসালটেশন', 'আর টি আই / এস টি আই কনসালটেশন', 'সাধারণ স্বাস্থ্য কনসালটেশন', 'শিশু স্বাস্থ্য কনসালটেশন'], 'Stethoscope'),
('pathology', 'প্যাথলজি সেবা', 'আমাদের প্যাথলজি বিভাগে নির্ভুল রিপোর্ট, দ্রুত সার্ভিস ও সাশ্রয়ী খরচে পরীক্ষা করা হয়।', 'অত্যাধুনিক ল্যাবরেটরি ও দক্ষ টেকনোলজিস্ট দ্বারা পরিচালিত।', 'text-indigo-500', 'bg-indigo-50', ARRAY['প্রেগনেন্সি টেস্ট', 'ব্লাড গ্রুপ টেস্ট', 'এইচবিএসএজি টেস্ট', 'ব্লাড সুগার টেস্ট', 'সুগার, এলবুমিন, পিএইচ', 'হিমোগ্লোবিন (%)', 'আল্ট্রাসোনোগ্রাফি'], 'Microscope'),
('vaccination', 'ভ্যাকসিনেশন', 'রোগ প্রতিরোধে WHO অনুমোদিত ভ্যাকসিনেশন সেবা প্রদান করা হয়।', 'মা ও শিশুর জন্য প্রয়োজনীয় সব ধরনের টিকা নিরাপদভাবে প্রদান করা হয়।', 'text-purple-500', 'bg-purple-50', ARRAY['হেপাটাইটিস বি ও জরায়ু ক্যান্সারের ভ্যাকসিন', 'টি.টি ও অন্যান্য টিকা'], 'Syringe')
on conflict (id) do nothing;

-- Seed Doctors
insert into doctors (id, name, specialty, experience, rating, image, branch_id, education, bio, languages, available_days) values
('dr-anderson', 'Dr. Michael Anderson', 'Cardiologist', '20+ Years', 4.9, 'dr-anderson.jpg', 'downtown', 'MD from Harvard Medical School', 'Dr. Anderson is a renowned cardiologist with over two decades of experience in treating complex heart conditions. He has pioneered several minimally invasive cardiac procedures.', ARRAY['English', 'Spanish'], ARRAY['Monday', 'Wednesday', 'Friday']),
('dr-mitchell', 'Dr. Sarah Mitchell', 'Pediatrician', '12+ Years', 4.8, 'dr-mitchell.jpg', 'westside', 'MD from Stanford University', 'Dr. Mitchell specializes in pediatric care with a focus on developmental health. She is passionate about creating a comfortable environment for children.', ARRAY['English', 'French'], ARRAY['Tuesday', 'Thursday', 'Saturday']),
('dr-garcia', 'Dr. Robert Garcia', 'Neurologist', '18+ Years', 4.9, 'dr-garcia.jpg', 'eastside', 'MD from Johns Hopkins University', 'Dr. Garcia is an expert in neurological disorders, with special expertise in stroke prevention and treatment. He leads our neurology research division.', ARRAY['English', 'Spanish', 'Portuguese'], ARRAY['Monday', 'Tuesday', 'Thursday']),
('dr-thompson', 'Dr. Emily Thompson', 'Orthopedic Surgeon', '15+ Years', 4.7, 'dr-thompson.jpg', 'north', 'MD from Yale School of Medicine', 'Dr. Thompson is a skilled orthopedic surgeon specializing in sports medicine and joint replacement. She has treated numerous professional athletes.', ARRAY['English'], ARRAY['Wednesday', 'Friday', 'Saturday']),
('dr-chen', 'Dr. Lisa Chen', 'Ophthalmologist', '14+ Years', 4.8, 'dr-chen.jpg', 'downtown', 'MD from Columbia University', 'Dr. Chen is an expert in treating complex eye conditions and has performed over 5,000 successful eye surgeries including LASIK and cataract removal.', ARRAY['English', 'Mandarin'], ARRAY['Monday', 'Wednesday', 'Friday']),
('dr-wilson', 'Dr. James Wilson', 'General Physician', '22+ Years', 4.9, 'dr-wilson.jpg', 'westside', 'MD from UCLA', 'Dr. Wilson provides comprehensive primary care with a holistic approach to patient wellness. He believes in preventive medicine and patient education.', ARRAY['English', 'German'], ARRAY['Tuesday', 'Thursday', 'Saturday'])
on conflict (id) do nothing;

-- Seed Gallery Items
-- Note: id is serial, so we let Postgres handle it, or we force it if we want exact IDs.
insert into gallery_items (src, alt, category) values
('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800', 'Hospital Exterior', 'Facility'),
('https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800', 'Modern Reception Area', 'Interior'),
('https://images.unsplash.com/photo-1551076805-e1869033e561?w=800', 'Operating Room', 'Medical'),
('https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800', 'Patient Room', 'Interior'),
('https://images.unsplash.com/photo-1516549655169-df83a0774514?w=800', 'Laboratory', 'Medical'),
('https://images.unsplash.com/photo-1581595219315-a187dd40c322?w=800', 'Waiting Area', 'Interior'),
('https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?w=800', 'Medical Equipment', 'Medical'),
('https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?w=800', 'Emergency Department', 'Facility'),
('https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800', 'Pharmacy', 'Facility'),
('https://images.unsplash.com/photo-1551190822-a9333d879b1f?w=800', 'Medical Team', 'Team'),
('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800', 'Doctor Consultation', 'Team'),
('https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=800', 'Physical Therapy', 'Medical');
