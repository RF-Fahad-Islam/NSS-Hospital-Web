import {
    Heart, Baby, Brain, Bone, Eye, Stethoscope,
    Syringe, Activity, Pill, Microscope, Scan, Ambulance,
} from 'lucide-vue-next'
// Images
import doctor1 from '@/assets/doctor-1.jpg'
import doctor2 from '@/assets/doctor-2.jpg'
import doctor3 from '@/assets/doctor-3.jpg'
import doctor4 from '@/assets/doctor-4.jpg'

export interface Branch {
    id: string;
    name: string;
    address: string;
    phone: string;
    email: string;
    mapUrl: string;
    image: string;
}

export interface Doctor {
    id: string;
    name: string;
    specialty: string;
    experience: string;
    rating: number;
    image: string;
    branchId: string;
    education: string;
    bio: string;
    languages: string[];
    availableDays: string[];
    isDoctor: boolean;
}

export interface Service {
    id: string;
    icon: any;
    title: string;
    description: string;
    fullDescription: string;
    color: string;
    bgColor: string;
    features: string[];
}

export const branches: Branch[] = [
    {
        id: 'downtown',
        name: 'Downtown Medical Center',
        address: '123 Main Street, Downtown, City 10001',
        phone: '+1 (555) 123-4567',
        email: 'downtown@medicareplus.com',
        mapUrl: 'https://maps.google.com',
        image: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
    },
    {
        id: 'westside',
        name: 'Westside Health Campus',
        address: '456 Oak Avenue, Westside, City 10002',
        phone: '+1 (555) 234-5678',
        email: 'westside@medicareplus.com',
        mapUrl: 'https://maps.google.com',
        image: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800',
    },
    {
        id: 'eastside',
        name: 'Eastside Community Hospital',
        address: '789 Pine Road, Eastside, City 10003',
        phone: '+1 (555) 345-6789',
        email: 'eastside@medicareplus.com',
        mapUrl: 'https://maps.google.com',
        image: 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=800',
    },
    {
        id: 'north',
        name: 'North Specialty Clinic',
        address: '321 Elm Boulevard, North District, City 10004',
        phone: '+1 (555) 456-7890',
        email: 'north@medicareplus.com',
        mapUrl: 'https://maps.google.com',
        image: 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=800',
    },
];

export const doctors: Doctor[] = [
    {
        id: 'dr-anderson',
        name: 'Dr. Michael Anderson',
        specialty: 'Cardiologist',
        experience: '20+ Years',
        rating: 4.9,
        image: doctor1,
        branchId: 'downtown',
        education: 'MD from Harvard Medical School',
        bio: 'Dr. Anderson is a renowned cardiologist with over two decades of experience in treating complex heart conditions. He has pioneered several minimally invasive cardiac procedures.',
        languages: ['English', 'Spanish'],
        availableDays: ['Monday', 'Wednesday', 'Friday'],
        isDoctor: true,
    },
    {
        id: 'dr-mitchell',
        name: 'Dr. Sarah Mitchell',
        specialty: 'Pediatrician',
        experience: '12+ Years',
        rating: 4.8,
        image: doctor2,
        branchId: 'westside',
        education: 'MD from Stanford University',
        bio: 'Dr. Mitchell specializes in pediatric care with a focus on developmental health. She is passionate about creating a comfortable environment for children.',
        languages: ['English', 'French'],
        availableDays: ['Tuesday', 'Thursday', 'Saturday'],
        isDoctor: true,
    },
    {
        id: 'dr-garcia',
        name: 'Dr. Robert Garcia',
        specialty: 'Neurologist',
        experience: '18+ Years',
        rating: 4.9,
        image: doctor3,
        branchId: 'eastside',
        education: 'MD from Johns Hopkins University',
        bio: 'Dr. Garcia is an expert in neurological disorders, with special expertise in stroke prevention and treatment. He leads our neurology research division.',
        languages: ['English', 'Spanish', 'Portuguese'],
        availableDays: ['Monday', 'Tuesday', 'Thursday'],
        isDoctor: true,
    },
    {
        id: 'dr-thompson',
        name: 'Dr. Emily Thompson',
        specialty: 'Orthopedic Surgeon',
        experience: '15+ Years',
        rating: 4.7,
        image: doctor4,
        branchId: 'north',
        education: 'MD from Yale School of Medicine',
        bio: 'Dr. Thompson is a skilled orthopedic surgeon specializing in sports medicine and joint replacement. She has treated numerous professional athletes.',
        languages: ['English'],
        availableDays: ['Wednesday', 'Friday', 'Saturday'],
        isDoctor: true,
    },
    {
        id: 'dr-chen',
        name: 'Dr. Lisa Chen',
        specialty: 'Ophthalmologist',
        experience: '14+ Years',
        rating: 4.8,
        image: doctor1,
        branchId: 'downtown',
        education: 'MD from Columbia University',
        bio: 'Dr. Chen is an expert in treating complex eye conditions and has performed over 5,000 successful eye surgeries including LASIK and cataract removal.',
        languages: ['English', 'Mandarin'],
        availableDays: ['Monday', 'Wednesday', 'Friday'],
        isDoctor: true,
    },
    {
        id: 'dr-wilson',
        name: 'Dr. James Wilson',
        specialty: 'General Physician',
        experience: '22+ Years',
        rating: 4.9,
        image: doctor2,
        branchId: 'westside',
        education: 'MD from UCLA',
        bio: 'Dr. Wilson provides comprehensive primary care with a holistic approach to patient wellness. He believes in preventive medicine and patient education.',
        languages: ['English', 'German'],
        availableDays: ['Tuesday', 'Thursday', 'Saturday'],
        isDoctor: true,
    },
];

export const services: Service[] = [
    {
        id: 'mr-service',
        icon: Activity,
        title: 'নিরাপদ এম আর (Safe M.R)',
        description: 'আমাদের ক্লিনিকে অভিজ্ঞ ও প্রশিক্ষিত স্বাস্থ্যকর্মীর মাধ্যমে নিরাপদ, গোপনীয় ও স্বাস্থ্যসম্মত এম আর সেবা প্রদান করা হয়।',
        fullDescription: 'আধুনিক পদ্ধতি ও পরিষ্কার পরিবেশে করা হওয়ায় ঝুঁকি অত্যন্ত কম এবং রোগীর স্বাস্থ্যের সর্বোচ্চ যত্ন নিশ্চিত করা হয়।',
        color: 'text-red-500',
        bgColor: 'bg-red-50',
        features: ['মাসিক নিয়মিত করণ (Menstrual Regulation)', 'গর্ভপাত পরবর্তী সেবা (PAC)', 'এম আর / ডি এন্ড সি (জটিলতা মুক্ত)', 'জরায়ুতে রিং পরামর্শ', 'এম আর / প্যাক ফলোআপ (৩০ দিনের মধ্যে)'],
    },
    {
        id: 'maternity',
        icon: Baby,
        title: 'নিরাপদ মাতৃত্ব (Safe Motherhood)',
        description: 'আমাদের ক্লিনিকে রয়েছে নিরাপদ ও স্বাস্থ্যসম্মত নরমাল ডেলিভারি সেবা।',
        fullDescription: 'প্রশিক্ষিত মিডওয়াইফ ও স্বাস্থ্যকর্মীদের মাধ্যমে মা ও নবজাতকের সর্বোচ্চ নিরাপত্তা নিশ্চিত করা হয়।',
        color: 'text-pink-500',
        bgColor: 'bg-pink-50',
        features: ['ডেলিভারি (নরমাল)', 'ডেলিভারি (সাইড সিজার)', 'গর্ভবতী মায়ের চেকআপ ও প্রসবপূর্ব সেবা'],
    },
    {
        id: 'family-planning',
        icon: Pill, // Changed from Users to Pill or similar if available, actually 'Pill' is imported. Check imports. Yes Pill is imported.
        title: 'পরিবার পরিকল্পনা সেবা',
        description: 'নারী ও পুরুষের জন্য দীর্ঘমেয়াদি ও স্থায়ী পরিবার পরিকল্পনা পদ্ধতি নিয়ে পরামর্শ ও সেবা।',
        fullDescription: 'নিরাপদ ও কার্যকর সরকারি অনুমোদিত জন্মনিয়ন্ত্রণ পদ্ধতি।',
        color: 'text-blue-500',
        bgColor: 'bg-blue-50',
        features: ['খাবার বড়ি (সরকারি-প্রতি পাতা)', 'কনডম (১০ পিস)', 'ইমার্জেন্সি কনট্রাসেপটিভ পিল', 'ইনজেকশন / ডিপো', 'আইইউডি / ইমপ্লান্ট / স্থায়ী পদ্ধতি'],
    },
    {
        id: 'reproductive-health',
        icon: Stethoscope,
        title: 'প্রজনন ও সাধারণ স্বাস্থ্য',
        description: 'মাসিক সমস্যা, বন্ধ্যাত্ব, হরমোনজনিত সমস্যা এবং সাধারণ রোগের চিকিৎসা ও পরামর্শ।',
        fullDescription: 'যৌনবাহিত সংক্রমণ প্রতিরোধ ও চিকিৎসার জন্য গোপনীয় ও নিরাপদ সেবা।',
        color: 'text-teal-500',
        bgColor: 'bg-teal-50',
        features: ['প্রজনন স্বাস্থ্য কনসালটেশন', 'আর টি আই / এস টি আই কনসালটেশন', 'সাধারণ স্বাস্থ্য কনসালটেশন', 'শিশু স্বাস্থ্য কনসালটেশন'],
    },
    {
        id: 'pathology',
        icon: Microscope,
        title: 'প্যাথলজি সেবা',
        description: 'আমাদের প্যাথলজি বিভাগে নির্ভুল রিপোর্ট, দ্রুত সার্ভিস ও সাশ্রয়ী খরচে পরীক্ষা করা হয়।',
        fullDescription: 'অত্যাধুনিক ল্যাবরেটরি ও দক্ষ টেকনোলজিস্ট দ্বারা পরিচালিত।',
        color: 'text-indigo-500',
        bgColor: 'bg-indigo-50',
        features: ['প্রেগনেন্সি টেস্ট', 'ব্লাড গ্রুপ টেস্ট', 'এইচবিএসএজি টেস্ট', 'ব্লাড সুগার টেস্ট', 'সুগার, এলবুমিন, পিএইচ', 'হিমোগ্লোবিন (%)', 'আল্ট্রাসোনোগ্রাফি'],
    },
    {
        id: 'vaccination',
        icon: Syringe,
        title: 'ভ্যাকসিনেশন',
        description: 'রোগ প্রতিরোধে WHO অনুমোদিত ভ্যাকসিনেশন সেবা প্রদান করা হয়।',
        fullDescription: 'মা ও শিশুর জন্য প্রয়োজনীয় সব ধরনের টিকা নিরাপদভাবে প্রদান করা হয়।',
        color: 'text-purple-500',
        bgColor: 'bg-purple-50',
        features: ['হেপাটাইটিস বি ও জরায়ু ক্যান্সারের ভ্যাকসিন', 'টি.টি ও অন্যান্য টিকা'],
    },
];

export const galleryImages = [
    {
        id: 1,
        src: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
        alt: 'Hospital Exterior',
        category: 'Facility',
    },
    {
        id: 2,
        src: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800',
        alt: 'Modern Reception Area',
        category: 'Interior',
    },
    {
        id: 3,
        src: 'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
        alt: 'Operating Room',
        category: 'Medical',
    },
    {
        id: 4,
        src: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800',
        alt: 'Patient Room',
        category: 'Interior',
    },
    {
        id: 5,
        src: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=800',
        alt: 'Laboratory',
        category: 'Medical',
    },
    {
        id: 6,
        src: 'https://images.unsplash.com/photo-1581595219315-a187dd40c322?w=800',
        alt: 'Waiting Area',
        category: 'Interior',
    },
    {
        id: 7,
        src: 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?w=800',
        alt: 'Medical Equipment',
        category: 'Medical',
    },
    {
        id: 8,
        src: 'https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?w=800',
        alt: 'Emergency Department',
        category: 'Facility',
    },
    {
        id: 9,
        src: 'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800',
        alt: 'Pharmacy',
        category: 'Facility',
    },
    {
        id: 10,
        src: 'https://images.unsplash.com/photo-1551190822-a9333d879b1f?w=800',
        alt: 'Medical Team',
        category: 'Team',
    },
    {
        id: 11,
        src: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
        alt: 'Doctor Consultation',
        category: 'Team',
    },
    {
        id: 12,
        src: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=800',
        alt: 'Physical Therapy',
        category: 'Medical',
    },
];
