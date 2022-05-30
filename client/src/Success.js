import React, {useEffect} from 'react'
import {useNavigate} from "react-router-dom";

function Success() {
    let navigate = useNavigate();

    useEffect(() => {
        setTimeout(() => {
            navigate('/search')
        }, 1000)
    })

    return (
        <div className=" bg-neutral-800 p-2 h-screen rounded-sm grid grid-rows-6">
            <h1 className="text-green-400 text-left font-semibold text-2xl leading-10">
                <span className="text-3xl font-bold tracking-wider">Successfully Connected!!</span>
            </h1>
        </div>
    )
}

export default Success